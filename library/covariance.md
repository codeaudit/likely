### Covariance
Compare to **[cv::calcCovarMatrix](http://docs.opencv.org/modules/core/doc/operations_on_arrays.html#calccovarmatrix)**.

    "library/multiply-transposed.md".import

    covariance :=
      src :->
        (multiply-transposed src src.average-row)

#### Generated LLVM IR
| Type   | Single-core | Multi-core |
|--------|-------------|------------|
| u8SXY  | [View](https://raw.githubusercontent.com/biometrics/likely/gh-pages/ir/benchmarks/covariance_f32X_u8SXY.ll)  | [View](https://raw.githubusercontent.com/biometrics/likely/gh-pages/ir/benchmarks/covariance_f32X_u8SXY_m.ll)  |
| i16SXY | [View](https://raw.githubusercontent.com/biometrics/likely/gh-pages/ir/benchmarks/covariance_f32X_i16SXY.ll) | [View](https://raw.githubusercontent.com/biometrics/likely/gh-pages/ir/benchmarks/covariance_f32X_i16SXY_m.ll) |
| f32XY  | [View](https://raw.githubusercontent.com/biometrics/likely/gh-pages/ir/benchmarks/covariance_f32X_f32XY.ll)  | [View](https://raw.githubusercontent.com/biometrics/likely/gh-pages/ir/benchmarks/covariance_f32X_f32XY_m.ll)  |
| f64XY  | [View](https://raw.githubusercontent.com/biometrics/likely/gh-pages/ir/benchmarks/covariance_f64X_f64XY.ll)  | [View](https://raw.githubusercontent.com/biometrics/likely/gh-pages/ir/benchmarks/covariance_f64X_f64XY_m.ll)  |
