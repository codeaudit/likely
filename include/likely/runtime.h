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

#ifndef LIKELY_RUNTIME_H
#define LIKELY_RUNTIME_H

#include <limits.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <likely/export.h>

#ifdef __cplusplus
extern "C" {
#endif // __cplusplus

/*!
 * \defgroup runtime Runtime
 * \brief Symbols required by compiled functions (\c likely/runtime.h).
 *
 * Statically compiled Likely algorithms will generally depend on these symbols
 * <i>and these symbols only</i>.
 *
 * Unless otherwise noted, these functions are implemented in \c src/runtime.c and designed to have no dependencies outside of the \c C Standard Library.
 * Use these symbols by linking against the \c likely_runtime static library,
 * the complete \c likely library, or by compiling the relevant source files
 * directly into your project.
 *
 * @{
 */

/*!
 * \brief How to interpret \ref likely_matrix::data.
 *
 * Available options are listed in \ref likely_type_mask.
 */
typedef uint32_t likely_type;

/*!
 * \brief \ref likely_type bit format.
 */
enum likely_type_mask
{
    likely_void      = 0x00000000, /*!< \brief Unknown type. */
    likely_depth     = 0x000000FF, /*!< \brief Bits per element. */
    likely_floating  = 0x00000100, /*!< \brief Elements are floating-point. */
    likely_llvm      = likely_depth | likely_floating, /*!< \brief The portion of the element type representable in \c LLVM. */
    likely_signed    = 0x00000200, /*!< \brief Elements are signed (integers). */
    likely_c_type    = likely_llvm | likely_signed, /*!< \brief The portion of the element type representable in \c C. */
    likely_saturated = 0x00000400, /*!< \brief Use saturated arithmetic with computations involving these elements. */
    likely_element   = likely_c_type | likely_saturated, /*!< \brief The portion of \ref likely_type indicating how to interpret elements. */
    likely_indirect  = 0x00000800, /*!< \brief \ref likely_matrix::data is \c sizeof(char*) bytes and contains a pointer to the data buffer which it does not own. */
    likely_u1  = 1, /*!< \brief 1-bit unsigned integer elements. */
    likely_u8  = 8, /*!< \brief 8-bit unsigned integer elements. */
    likely_u16 = 16, /*!< \brief 16-bit unsigned integer elements. */
    likely_u32 = 32, /*!< \brief 32-bit unsigned integer elements. */
    likely_u64 = 64, /*!< \brief 64-bit unsigned integer elements. */
    likely_i8  = 8  | likely_signed, /*!< \brief 8-bit signed integer elements. */
    likely_i16 = 16 | likely_signed, /*!< \brief 16-bit signed integer elements. */
    likely_i32 = 32 | likely_signed, /*!< \brief 32-bit signed integer elements. */
    likely_i64 = 64 | likely_signed, /*!< \brief 64-bit signed integer elements. */
    likely_f16 = 16 | likely_floating, /*!< \brief 16-bit floating-point elements. */
    likely_f32 = 32 | likely_floating, /*!< \brief 32-bit floating-point elements. */
    likely_f64 = 64 | likely_floating, /*!< \brief 64-bit floating-point elements. */
    likely_multi_channel   = 0x00001000, /*!< \brief \ref likely_matrix::channels > 1. */
    likely_multi_column    = 0x00002000, /*!< \brief \ref likely_matrix::columns > 1. */
    likely_multi_row       = 0x00004000, /*!< \brief \ref likely_matrix::rows > 1. */
    likely_multi_frame     = 0x00008000, /*!< \brief \ref likely_matrix::frames > 1. */
    likely_multi_dimension = likely_multi_channel | likely_multi_column | likely_multi_row | likely_multi_frame, /*!< \brief The portion of \ref likely_type indicating matrix dimensionality. Used for loop optimizations. */
    likely_text            = likely_i8 | likely_multi_channel, /*!< \brief Text file. */
    likely_image_grayscale = likely_u8 | likely_multi_column | likely_multi_row, /*!< \brief Grayscale image. */
    likely_image           = likely_image_grayscale | likely_multi_channel, /*!< \brief Color image. */
    likely_video_grayscale = likely_image_grayscale | likely_multi_frame, /*!< \brief Grayscale video. */
    likely_video           = likely_image | likely_multi_frame, /*!< \brief Color video. */
    likely_uchar     = sizeof(char)        * CHAR_BIT, /*!< \brief C-compatible \c unsigned \c char type. */
    likely_ushort    = sizeof(short)       * CHAR_BIT, /*!< \brief C-compatible \c unsigned \c short type. */
    likely_uint      = sizeof(int)         * CHAR_BIT, /*!< \brief C-compatible \c unsigned \c int type. */
    likely_ulong     = sizeof(long)        * CHAR_BIT, /*!< \brief C-compatible \c unsigned \c long type. */
    likely_ulonglong = sizeof(long long)   * CHAR_BIT, /*!< \brief C-compatible \c unsigned \c long \c long type. */
    likely_char     = likely_uchar     | likely_signed, /*!< \brief C-compatible \c char type. */
    likely_short    = likely_ushort    | likely_signed, /*!< \brief C-compatible \c short type. */
    likely_int      = likely_uint      | likely_signed, /*!< \brief C-compatible \c int type. */
    likely_long     = likely_ulong     | likely_signed, /*!< \brief C-compatible \c long type. */
    likely_longlong = likely_ulonglong | likely_signed, /*!< \brief C-compatible \c long \c long type. */
    likely_bool        = sizeof(bool)        * CHAR_BIT, /*!< \brief C-compatible \c bool type. */
    likely_size_t      = sizeof(size_t)      * CHAR_BIT, /*!< \brief C-compatible \c size_t type. */
    likely_ptrdiff_t   = sizeof(ptrdiff_t)   * CHAR_BIT, /*!< \brief C-compatible \c ptrdiff_t type. */
    likely_float       = sizeof(float)       * CHAR_BIT | likely_floating, /*!< \brief C-compatible \c float type. */
    likely_double      = sizeof(double)      * CHAR_BIT | likely_floating, /*!< \brief C-compatible \c double type. */
    likely_long_double = sizeof(long double) * CHAR_BIT | likely_floating, /*!< \brief C-compatible \c long \c double type. */
    likely_compound_pointer = 0x40000000, /*!< \brief Compound pointer type. */
    likely_compound_struct  = 0x80000000, /*!< \brief Compound struct type. */
};

// Disable 'nonstandard extension used : zero-sized array in struct/union' warning
#ifdef _MSC_VER
#  pragma warning(disable: 4200)
#endif // _MSC_VER

typedef struct likely_matrix const *likely_const_mat; /*!< \brief Pointer to a constant \ref likely_matrix. */
typedef struct likely_matrix *likely_mat; /*!< \brief Pointer to a \ref likely_matrix. */

/*!
 * \brief Multi-dimensional data for input and output to functions.
 *
 * The fields excluding \ref data are collectively referred to as the matrix _header_.
 * In contrast to most image processing libraries which tend to feature 3-dimensional matrices (_channels_, _columns_ and _rows_), Likely includes a fourth dimension, _frames_, in order to facilitate processing videos and image collections.
 *
 * \par Construction
 * | Function              | Description                 |
 * |-----------------------|-----------------------------|
 * | \ref likely_new       | \copybrief likely_new       |
 * | \ref likely_scalar    | \copybrief likely_scalar    |
 * | \ref likely_string    | \copybrief likely_string    |
 * | \ref likely_read      | \copybrief likely_read      |
 * | \ref likely_decode    | \copybrief likely_decode    |
 * | \ref likely_to_string | \copybrief likely_to_string |
 * | \ref likely_render    | \copybrief likely_render    |
 *
 * \par Element Access
 * By convention, element layout in \ref likely_matrix::data with respect to decreasing spatial locality is: channel, column, row, frame.
 * Thus an element at channel _c_, column _x_, row _y_ and frame _t_, can be retrieved like:
 * \snippet src/runtime.c likely_element implementation.
 *
 * Convenience functions \ref likely_element and \ref likely_set_element are provided for individual element access.
 * However, these functions should be used sparingly as they are inefficient for iterating over a large numbers of elements due to the repeated index calculations.
 *
 * \anchor serialization
 * \par Serialization
 * The in-memory and on-disk representations of a \ref likely_matrix are isomorphic.
 * In other words, you can serialize a matrix like:
 * \code
 * likely_const_mat mat = ...;
 * FILE *file = ...;
 * fwrite((const void *) mat, sizeof(likely_matrix) + likely_bytes(mat), 1, file);
 * \endcode
 * Alternatively, you can just call \ref likely_write.
 * Likely uses a <c>.lm</c> file extension for matricies.
 *
 * \see \ref reference_counting
 */
struct likely_matrix
{
    uint32_t ref_count; /*!< \brief Reference count used by \ref likely_retain_mat and \ref likely_release_mat to track ownership. */
    likely_type type; /*!< \brief Interpretation of \ref data. */
    uint32_t channels; /*!< \brief Sub-spatial dimensionality. */
    uint32_t columns;  /*!< \brief Horizontal dimensionality. */
    uint32_t rows;     /*!< \brief Vertical dimensionality. */
    uint32_t frames;   /*!< \brief Super-spatial or temporal dimensionality. */
    char data[]; /*!< \brief Buffer with guaranteed 32-byte alignment. */
};

/*!
 * \brief Get the size of \ref likely_matrix::data in bytes.
 *
 * \par Implementation
 * \snippet src/runtime.c likely_bytes implementation.
 * \param[in] mat The matrix from which to calculate the data buffer size.
 * \return The length of \ref likely_matrix::data in bytes.
 * \remark This function is \ref thread-safe.
 */
LIKELY_EXPORT size_t likely_bytes(likely_const_mat mat);

/*!
 * \brief Helper function to retrieve a pointer to the matrix data buffer.
 *
 * This function is only useful for matricies that might be \ref likely_indirect.
 * Otherwise just use \ref likely_matrix::data directly.
 *
 * \par Implementation
 * \snippet src/runtime.c likely_data implementation.
 * \param[in] mat The matrix from which to retrieve the data buffer pointer.
 * \return Pointer to the data buffer.
 * \remark This function is \ref thread-safe.
 */
LIKELY_EXPORT const char *likely_data(likely_const_mat mat);

/*!
 * \brief Check if a \ref likely_matrix represents a string.
 *
 * \par Implementation
 * \snippet src/runtime.c likely_is_string implementation.
 * \param[in] m The matrix to test.
 * \return \c true if \ref likely_matrix::data is a string, \c false otherwise.
 * \remark This function is \ref thread-safe.
 * \see \ref likely_string
 */
LIKELY_EXPORT bool likely_is_string(likely_const_mat m);

/*!
 * \brief Allocate and initialize a new \ref likely_matrix.
 *
 * In the case that \p data is NULL then the returned \ref likely_matrix::data is uninitialized.
 * Otherwise, the returned \ref likely_matrix::data is initialized by copying the contents of \p data.
 * In the latter case, \p data should be at least size \ref likely_bytes.
 *
 * The \ref likely_multi_dimension component of \ref likely_matrix::type is checked against \p channels, \p columns, \p rows and \p frames for correctness.
 * All four axis must be non-zero.
 *
 * \par Implementation
 * \snippet src/runtime.c likely_new implementation.
 * \param[in] type \ref likely_matrix::type.
 * \param[in] channels \ref likely_matrix::channels.
 * \param[in] columns \ref likely_matrix::columns.
 * \param[in] rows \ref likely_matrix::rows.
 * \param[in] frames \ref likely_matrix::frames.
 * \param[in] data \ref likely_matrix::data.
 * \return A pointer to the new \ref likely_matrix if successful, or \c NULL otherwise.
 * \remark This function is \ref thread-safe.
 * \see \ref likely_scalar \ref likely_string
 */
LIKELY_EXPORT likely_mat likely_new(likely_type type, uint32_t channels, uint32_t columns, uint32_t rows, uint32_t frames, void const *data);

/*!
 * \brief Allocate and initialize a new low-dimensional \ref likely_matrix.
 *
 * Convenient alternative to \ref likely_new for low-dimensional vectors.
 * \par Implementation
 * \snippet src/runtime.c likely_scalar implementation.
 * \param[in] type \ref likely_matrix::type.
 * \param[in] values Array of element values.
 * \param[in] n Length of \p values.
 * \return A pointer to the new \ref likely_matrix if successful, or \c NULL otherwise.
 * \remark This function is \ref thread-safe.
 */
LIKELY_EXPORT likely_mat likely_scalar(likely_type type, const double *values, uint32_t n);

/*!
 * \brief Allocate and initialize a new \ref likely_matrix from a string.
 *
 * Convenient alternative to \ref likely_new.
 * The returned \ref likely_matrix::data is a valid \c C string of length <tt>\ref likely_matrix::channels - 1</tt>.
 * \par Implementation
 * \snippet src/runtime.c likely_string implementation.
 * \param[in] str String used to initialized \ref likely_matrix::data.
 * \return A pointer to the new \ref likely_matrix if successful, or \c NULL otherwise.
 * \remark This function is \ref thread-safe.
 * \see \ref likely_is_string
 */
LIKELY_EXPORT likely_mat likely_string(const char *str);

/*!
 * \brief Retain a reference to a matrix.
 *
 * Increments \ref likely_matrix::ref_count.
 * \par Implementation
 * \snippet src/runtime.c likely_retain_mat implementation.
 * \param[in] mat Matrix to add a reference. May be \c NULL.
 * \return \p mat.
 * \remark This function is \ref reentrant.
 * \see \ref likely_release_mat
 */
LIKELY_EXPORT likely_mat likely_retain_mat(likely_const_mat mat);

/*!
 * \brief Release a reference to a matrix.
 *
 * Decrements \ref likely_matrix::ref_count.
 * Frees the matrix memory when the reference count is decremented to zero.
 * \par Implementation
 * \snippet src/runtime.c likely_release_mat implementation.
 * \param[in] mat Matrix to subtract a reference. May be \c NULL.
 * \remark This function is \ref reentrant.
 * \see \ref likely_retain_mat
 */
LIKELY_EXPORT void likely_release_mat(likely_const_mat mat);

/*!
 * \brief Get the value of a \ref likely_matrix at a specified location.
 *
 * A \c NULL \p m or out-of-bounds \p c, \p x, \p y or \p t will return \p NAN.
 * \c assert is called if the matrix does not have a type convertible to \c C.
 * \par Implementation
 * \snippet src/runtime.c likely_element implementation.
 * \param[in] m The matrix to index into.
 * \param[in] c Channel.
 * \param[in] x Column.
 * \param[in] y Row.
 * \param[in] t Frame.
 * \return The value of the matrix at the specified location.
 * \remark This function is \ref thread-safe.
 * \see \ref likely_set_element
 */
LIKELY_EXPORT double likely_get_element(likely_const_mat m, uint32_t c, uint32_t x, uint32_t y, uint32_t t);

/*!
 * \brief Set the value of a \ref likely_matrix at a specified location.
 *
 * A \c NULL \p m or out-of-bounds \p c, \p x, \p y or \p t will return without setting \p value.
 * \c assert is called if the matrix does not have a type convertible to \c C.
 * \param[in] m The matrix to index into.
 * \param[in] value The value to set the element to.
 * \param[in] c Channel.
 * \param[in] x Column.
 * \param[in] y Row.
 * \param[in] t Frame.
 * \remark This function is \ref thread-safe.
 * \see \ref likely_get_element
 */
LIKELY_EXPORT void likely_set_element(likely_mat m, double value, uint32_t c, uint32_t x, uint32_t y, uint32_t t);

/*!
 * \brief Set parallel execution thread count.
 *
 * The default thread count is [thread::hardware_concurrency()](http://en.cppreference.com/w/cpp/thread/thread/hardware_concurrency).
 * \param[in] thread_count Number of worker threads.
 * \remark This function is \ref thread-unsafe.
 * \see \ref likely_get_thread_count \ref likely_default_settings
 */
LIKELY_EXPORT void likely_set_thread_count(unsigned thread_count);

/*!
 * \brief Get parallel execution thread count.
 * \return Number of worker threads.
 * \remark This function is \ref thread-safe.
 * \see \ref likely_set_thread_count \ref likely_default_settings \ref likely_fork
 */
LIKELY_EXPORT unsigned likely_get_thread_count();

/*!
 * \brief A special kind of function designed to be run in parallel.
 * \see \ref likely_fork
 */
typedef void (*likely_thunk)(void *args, size_t start, size_t stop);

/*!
 * \brief Execute work in parallel.
 *
 * The number of threads to use is governed by \ref likely_get_thread_count.
 *
 * In contrast to \ref likely_dynamic, thunk parameters are known at compile time and may therefore take an arbitrary internally-defined structure.
 * The implementation is very similar to how \a OpenMP works.
 * [Here](https://software.intel.com/en-us/blogs/2010/07/23/thunk-you-very-much-or-how-do-openmp-compilers-work-part-2) is a good introductory article on the subject.
 *
 * This function is implemented in \c src/runtime_stdthread.cpp and depends on the presence of a <tt>C++11</tt>-compatible standard library.
 * \note This function is used internally and should not be called directly.
 * \param[in] thunk The function to run.
 * \param[in] args The arguments to propogate to \p thunk.
 * \param[in] size The range [0, \p size) over which to execute \p thunk.
 * \remark This function is \ref thread-safe.
 */
LIKELY_EXPORT void likely_fork(likely_thunk thunk, void *args, size_t size);

/*!
 * \brief Initialize the co-processor for heterogeneous execution.
 * \return \c true if the system has a viable co-processor, \c false otherwise.
 */
LIKELY_EXPORT bool likely_initialize_coprocessor();

/** @} */ // end of runtime

#ifdef __cplusplus
}
#endif // __cplusplus

#endif // LIKELY_RUNTIME_H
