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

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <likely/likely_export.h>

#ifdef __cplusplus
extern "C" {
#endif

// Matrix types
typedef uint8_t *likely_data;
typedef uintptr_t likely_size;
typedef uint32_t likely_type; /* Depth : 8
                                 Signed : 1
                                 Floating : 1
                                 Parallel : 1
                                 Heterogeneous : 1
                                 Single-channel : 1
                                 Single-column : 1
                                 Single-row : 1
                                 Single-frame : 1
                                 Saturation : 1
                                 Reserved : 15 */

// Standard type masks and values
enum likely_type_field
{
    likely_type_null     = 0x00000000,
    likely_type_depth    = 0x000000FF,
    likely_type_signed   = 0x00000100,
    likely_type_floating = 0x00000200,
    likely_type_mask     = likely_type_depth | likely_type_signed | likely_type_floating,
    likely_type_u8  = 8,
    likely_type_u16 = 16,
    likely_type_u32 = 32,
    likely_type_u64 = 64,
    likely_type_i8  = 8  | likely_type_signed,
    likely_type_i16 = 16 | likely_type_signed,
    likely_type_i32 = 32 | likely_type_signed,
    likely_type_i64 = 64 | likely_type_signed,
    likely_type_f16 = 16 | likely_type_floating | likely_type_signed,
    likely_type_f32 = 32 | likely_type_floating | likely_type_signed,
    likely_type_f64 = 64 | likely_type_floating | likely_type_signed,
    likely_type_parallel        = 0x00000400,
    likely_type_heterogeneous   = 0x00000800,
    likely_type_multi_channel   = 0x00001000,
    likely_type_multi_column    = 0x00002000,
    likely_type_multi_row       = 0x00004000,
    likely_type_multi_frame     = 0x00008000,
    likely_type_multi_dimension = 0x0000F000,
    likely_type_saturation      = 0x00010000,
    likely_type_reserved        = 0xFFFE0000
};

// The main datatype in Likely
typedef struct likely_matrix_struct
{
    struct likely_matrix_private *d_ptr;
    likely_data data;
    likely_size channels, columns, rows, frames;
    likely_type type;
} *likely_matrix;

// Abort-style error handling
LIKELY_EXPORT void likely_assert(bool condition, const char *format, ...);

// Query and edit the type
LIKELY_EXPORT int  likely_depth(likely_type type);
LIKELY_EXPORT void likely_set_depth(likely_type *type, int depth);
LIKELY_EXPORT bool likely_signed(likely_type type);
LIKELY_EXPORT void likely_set_signed(likely_type *type, bool signed_);
LIKELY_EXPORT bool likely_floating(likely_type type);
LIKELY_EXPORT void likely_set_floating(likely_type *type, bool floating);
LIKELY_EXPORT bool likely_parallel(likely_type type);
LIKELY_EXPORT void likely_set_parallel(likely_type *type, bool parallel);
LIKELY_EXPORT bool likely_heterogeneous(likely_type type);
LIKELY_EXPORT void likely_set_heterogeneous(likely_type *type, bool heterogeneous);
LIKELY_EXPORT bool likely_multi_channel(likely_type type);
LIKELY_EXPORT void likely_set_multi_channel(likely_type *type, bool multi_channel);
LIKELY_EXPORT bool likely_multi_column(likely_type type);
LIKELY_EXPORT void likely_set_multi_column(likely_type *type, bool multi_column);
LIKELY_EXPORT bool likely_multi_row(likely_type type);
LIKELY_EXPORT void likely_set_multi_row(likely_type *type, bool multi_row);
LIKELY_EXPORT bool likely_multi_frame(likely_type type);
LIKELY_EXPORT void likely_set_multi_frame(likely_type *type, bool multi_frame);
LIKELY_EXPORT bool likely_saturation(likely_type type);
LIKELY_EXPORT void likely_set_saturation(likely_type *type, bool saturation);
LIKELY_EXPORT int  likely_reserved(likely_type type);
LIKELY_EXPORT void likely_set_reserved(likely_type *type, int reserved);

// Matrix size
LIKELY_EXPORT likely_size likely_elements(const likely_matrix m);
LIKELY_EXPORT likely_size likely_bytes(const likely_matrix m);

// Matrix creation
LIKELY_EXPORT likely_matrix likely_new(likely_type type, likely_size channels, likely_size columns, likely_size rows, likely_size frames, likely_data data, int8_t copy);
LIKELY_EXPORT likely_matrix likely_scalar(double value);
LIKELY_EXPORT likely_matrix likely_copy(const likely_matrix m, int8_t clone);
LIKELY_EXPORT likely_matrix likely_retain(likely_matrix m);
LIKELY_EXPORT void likely_release(likely_matrix m);

// Element access
LIKELY_EXPORT double likely_element(const likely_matrix m, likely_size c, likely_size x, likely_size y, likely_size t);
LIKELY_EXPORT void likely_set_element(likely_matrix m, double value, likely_size c, likely_size x, likely_size y, likely_size t);

// Type conversion
LIKELY_EXPORT const char *likely_type_to_string(likely_type type); // Return value managed internally and guaranteed until the next call to this function
LIKELY_EXPORT likely_type likely_type_from_string(const char *str);
LIKELY_EXPORT likely_type likely_type_from_value(double value);
LIKELY_EXPORT likely_type likely_type_from_types(likely_type lhs, likely_type rhs);

typedef uint8_t likely_arity;

#ifdef __cplusplus
}
#endif

#endif // LIKELY_RUNTIME_H