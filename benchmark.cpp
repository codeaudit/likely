/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Copyright 2013 Joshua C. Klontz                                           *
 *                                                                           *
 * Licensed under the Apache License, Version 2.0 (the "License");           *
 * you may not use this file except in compliance with the License.          *
 * You may obtain a copy of the License at                                   *
 *                                                                           *
 *     http://www.apache.org/licenses/LICENSE-2.0                            *
 *                                                                           *
 * Unless required by applicable law or agreed to in writing, software       *
 * distributed under the License is distributed on an "AS IS" BASIS,         *
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  *
 * See the License for the specific language governing permissions and       *
 * limitations under the License.                                            *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#include <ctime>
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <lua.hpp>

#include "likely.h"
#include "opencv.shim"

using namespace cv;
using namespace std;

#define LIKELY_ERROR_TOLERANCE 0.0001
#define LIKELY_TEST_SECONDS 1

// Optional arguments to run only a subset of the benchmarks
static bool        BenchmarkExamples = false;
static string      BenchmarkFunction = "";
static likely_type BenchmarkType     = likely_type_null;
static int         BenchmarkSize     = 0;
static bool        BenchmarkSerial   = false;
static bool        BenchmarkParallel = false;

static Mat generateData(int rows, int columns, likely_type type)
{
    static Mat m;
    if (!m.data) {
        m = imread("../img/Lenna.tiff");
        assert(m.data);
        cvtColor(m, m, CV_BGR2GRAY);
    }

    Mat n;
    resize(m, n, Size(columns, rows), 0, 0, INTER_NEAREST);
    n.convertTo(n, typeToDepth(type));
    return n;
}

struct Test
{
    void run() const
    {
        if (!BenchmarkFunction.empty() && BenchmarkFunction != function()) return;

        for (likely_type type : types()) {
            if ((BenchmarkType != likely_type_null) && (BenchmarkType != type)) continue;

            for (int size : sizes()) {
                if ((BenchmarkSize != 0) && (BenchmarkSize != size)) continue;

                // Generate input matrix
                Mat src = generateData(size, size, type);
                likely_mat srcLikely = fromCvMat(src);
                likely_function_1 f = (likely_function_1) likely_compile(function(), 1, srcLikely);
                likely_release(srcLikely);

                // Test correctness
                testCorrectness(f, src, false);
                testCorrectness(f, src, true);

                // Test speed
                Speed baseline = testBaselineSpeed(src);

                if (BenchmarkSerial) {
                    Speed serial = testLikelySpeed(f, src, false);
                    printf("%s \t%s \t%d \tSerial \t%.2e\n", function(), likely_type_to_string(type), size, serial.Hz/baseline.Hz);
                }

                if (BenchmarkParallel) {
                    Speed parallel = testLikelySpeed(f, src, true);
                    printf("%s \t%s \t%d \tParallel \t%.2e\n", function(), likely_type_to_string(type), size, parallel.Hz/baseline.Hz);
                }
            }
        }
    }

    static void runExample(const char *source)
    {
        static lua_State *L = likely_exec("");
        likely_exec(source, L);
        clock_t startTime, endTime;
        int iter = 0;
        startTime = endTime = clock();
        while ((endTime-startTime) / CLOCKS_PER_SEC < LIKELY_TEST_SECONDS) {
            likely_exec(source, L);
            endTime = clock();
            iter++;
        }
        Speed speed(iter, startTime, endTime);
        const size_t exampleStartPos = 3;
        const size_t exampleNameSize = string(source).find('\n') - exampleStartPos;
        printf("%s \t%.2e \n", string(source).substr(exampleStartPos, exampleNameSize).c_str(), speed.Hz);
    }

protected:
    virtual const char *function() const = 0;
    virtual cv::Mat computeBaseline(const cv::Mat &src) const = 0;
    virtual std::vector<likely_type> types() const
    {
        std::vector<likely_type> types;
//        types.push_back(likely_type_u8);
//        types.push_back(likely_type_i16);
        types.push_back(likely_type_i32);
        types.push_back(likely_type_f32);
        types.push_back(likely_type_f64);
        return types;
    }

    virtual std::vector<int> sizes() const
    {
        std::vector<int> sizes;
        sizes.push_back(4);
        sizes.push_back(8);
        sizes.push_back(16);
        sizes.push_back(32);
        sizes.push_back(64);
        sizes.push_back(128);
        sizes.push_back(256);
        sizes.push_back(512);
        sizes.push_back(1024);
        sizes.push_back(2048);
        sizes.push_back(4096);
        return sizes;
    }

private:
    struct Speed
    {
        int iterations;
        double Hz;
        Speed() : iterations(-1), Hz(-1) {}
        Speed(int iter, clock_t startTime, clock_t endTime)
            : iterations(iter), Hz(double(iter) * CLOCKS_PER_SEC / (endTime-startTime)) {}
    };

    static likely_mat fromCvMat(const Mat &src)
    {
        likely_mat m = ::fromCvMat(src, false);
        if (!likely_floating(m->type) && (likely_depth(m->type) <= 16))
            likely_set_saturation(&m->type, true);
        return m;
    }

    void testCorrectness(likely_function_1 f, const cv::Mat &src, bool parallel) const
    {
        Mat dstOpenCV = computeBaseline(src);
        likely_mat srcLikely = fromCvMat(src);
        likely_set_parallel(&srcLikely->type, parallel);
        likely_mat dstLikely = f(srcLikely);

        Mat errorMat = abs(toCvMat(dstLikely) - dstOpenCV);
        errorMat.convertTo(errorMat, CV_32F);
        threshold(errorMat, errorMat, LIKELY_ERROR_TOLERANCE, 1, THRESH_BINARY);
        const double errors = norm(errorMat, NORM_L1);
        if (errors > 0) {
            likely_mat cvLikely = fromCvMat(dstOpenCV);
            stringstream errorLocations;
            errorLocations << "input\topencv\tlikely\trow\tcolumn\n";
            for (int i=0; i<src.rows; i++)
                for (int j=0; j<src.cols; j++)
                    if (errorMat.at<float>(i, j) == 1)
                        errorLocations << likely_element(srcLikely, 0, j, i) << "\t"
                                       << likely_element(cvLikely,  0, j, i) << "\t"
                                       << likely_element(dstLikely, 0, j, i) << "\t"
                                       << i << "\t" << j << "\n";
            fprintf(stderr, "Test for %s differs in %g locations:\n%s", function(), errors, errorLocations.str().c_str());
            likely_release(cvLikely);
        }

        likely_release(srcLikely);
        likely_release(dstLikely);
    }

    Speed testBaselineSpeed(const cv::Mat &src) const
    {
        clock_t startTime, endTime;
        int iter = 0;
        startTime = endTime = clock();
        while ((endTime-startTime) / CLOCKS_PER_SEC < LIKELY_TEST_SECONDS) {
            computeBaseline(src);
            endTime = clock();
            iter++;
        }
        return Test::Speed(iter, startTime, endTime);
    }

    Speed testLikelySpeed(likely_function_1 f, const cv::Mat &src, bool parallel) const
    {
        likely_mat srcLikely = fromCvMat(src);
        likely_set_parallel(&srcLikely->type, parallel);

        clock_t startTime, endTime;
        int iter = 0;
        startTime = endTime = clock();
        while ((endTime-startTime) / CLOCKS_PER_SEC < LIKELY_TEST_SECONDS) {
            likely_mat dstLikely = f(srcLikely);
            likely_release(dstLikely);
            endTime = clock();
            iter++;
        }
        likely_release(srcLikely);
        return Test::Speed(iter, startTime, endTime);
    }
};

class addTest : public Test {
    const char *function() const { return "add(32)"; }
    Mat computeBaseline(const Mat &src) const { Mat dst; add(src, 32, dst); return dst; }
};

class subtractTest : public Test {
    const char *function() const { return "subtract(32)"; }
    Mat computeBaseline(const Mat &src) const { Mat dst; subtract(src, 32, dst); return dst; }
};

class multiplyTest : public Test {
    const char *function() const { return "multiply(2)"; }
    Mat computeBaseline(const Mat &src) const { Mat dst; multiply(src, 2, dst); return dst; }
};

class divideTest : public Test {
    const char *function() const { return "divide(2)"; }
    Mat computeBaseline(const Mat &src) const { Mat dst; divide(src, 2, dst); return dst; }
};

class maddTest : public Test {
    const char *function() const { return "madd(2,3)"; }
    Mat computeBaseline(const Mat &src) const { Mat dst; src.convertTo(dst, src.depth(), 2, 3); return dst; }
};

class logTest : public Test {
    const char *function() const { return "log()"; }
    Mat computeBaseline(const Mat &src) const {Mat dst; log(src, dst); return dst; }
};

int main(int argc, char *argv[])
{
    // Parse arguments
    for (int i=1; i<argc; i++) {
        if      (!strcmp("-h", argv[i])) printf("benchmark [--examples] [-function <str>] [-type <type>] [-size <int>]\n");
        else if (!strcmp("--examples", argv[i])) BenchmarkExamples = true;
        else if (!strcmp("--serial", argv[i])) BenchmarkSerial = true;
        else if (!strcmp("--parallel", argv[i])) BenchmarkParallel = true;
        else if (!strcmp("-function", argv[i])) BenchmarkFunction = argv[++i];
        else if (!strcmp("-type", argv[i])) BenchmarkType = likely_string_to_type(argv[++i]);
        else if (!strcmp("-size", argv[i])) BenchmarkSize = atoi(argv[++i]);
        else    { printf("Unrecognized argument: %s\nTry running 'benchmark -h' for help", argv[i]); return 1; }
    }

    if (!BenchmarkSerial && !BenchmarkParallel)
        BenchmarkSerial = BenchmarkParallel = true;

    // Print to console immediately
    setbuf(stdout, NULL);

    if (BenchmarkExamples) {
        printf("Example \tSpeed\n");
        lua_State *L = likely_exec("");
        lua_getfield(L, -1, "likely");
        lua_getfield(L, -1, "examples");
        lua_pushnil(L);
        while (lua_next(L, -2)) {
            Test::runExample(lua_tostring(L, -1));
            lua_pop(L, 1);
        }
        lua_pop(L, 2);
        lua_close(L);
    } else {
        printf("Function \tType \tSize \tExecution \tSpeedup\n");
        addTest().run();
        subtractTest().run();
        multiplyTest().run();
        divideTest().run();
//        maddTest().run();
//        logTest().run();
    }

    return 0;
}

