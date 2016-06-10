; ModuleID = 'likely'
source_filename = "likely"

%u0CXYT = type { i32, i32, i32, i32, i32, i32, [0 x i8] }
%f32XY = type { i32, i32, i32, i32, i32, i32, [0 x float] }
%f32CXY = type { i32, i32, i32, i32, i32, i32, [0 x float] }

; Function Attrs: nounwind
declare void @llvm.assume(i1) #0

; Function Attrs: argmemonly nounwind
declare noalias %u0CXYT* @likely_new(i32 zeroext, i32 zeroext, i32 zeroext, i32 zeroext, i32 zeroext, i8* noalias nocapture) #1

; Function Attrs: norecurse nounwind
define private void @convert_grayscale_tmp_thunk0({ %f32XY*, %f32CXY* }* noalias nocapture readonly, i64, i64) #2 {
entry:
  %3 = getelementptr inbounds { %f32XY*, %f32CXY* }, { %f32XY*, %f32CXY* }* %0, i64 0, i32 0
  %4 = load %f32XY*, %f32XY** %3, align 8
  %5 = getelementptr inbounds { %f32XY*, %f32CXY* }, { %f32XY*, %f32CXY* }* %0, i64 0, i32 1
  %6 = load %f32CXY*, %f32CXY** %5, align 8
  %7 = getelementptr inbounds %f32CXY, %f32CXY* %6, i64 0, i32 3
  %columns1 = load i32, i32* %7, align 4, !range !0
  %dst_y_step = zext i32 %columns1 to i64
  %8 = getelementptr inbounds %f32CXY, %f32CXY* %6, i64 0, i32 2
  %channels = load i32, i32* %8, align 4, !range !0
  %src_c = zext i32 %channels to i64
  %9 = mul nuw nsw i64 %dst_y_step, %2
  br label %y_body

y_body:                                           ; preds = %y_body, %entry
  %y = phi i64 [ %1, %entry ], [ %y_increment, %y_body ]
  %10 = mul nuw nsw i64 %y, %src_c
  %11 = getelementptr %f32CXY, %f32CXY* %6, i64 0, i32 6, i64 %10
  %12 = load float, float* %11, align 4, !llvm.mem.parallel_loop_access !1
  %13 = add nuw nsw i64 %10, 1
  %14 = getelementptr %f32CXY, %f32CXY* %6, i64 0, i32 6, i64 %13
  %15 = load float, float* %14, align 4, !llvm.mem.parallel_loop_access !1
  %16 = add nuw nsw i64 %10, 2
  %17 = getelementptr %f32CXY, %f32CXY* %6, i64 0, i32 6, i64 %16
  %18 = load float, float* %17, align 4, !llvm.mem.parallel_loop_access !1
  %19 = fmul fast float %12, 0x3FBD2F1AA0000000
  %20 = fmul fast float %15, 0x3FE2C8B440000000
  %21 = fadd fast float %20, %19
  %22 = fmul fast float %18, 0x3FD322D0E0000000
  %23 = fadd fast float %21, %22
  %24 = getelementptr %f32XY, %f32XY* %4, i64 0, i32 6, i64 %y
  store float %23, float* %24, align 4, !llvm.mem.parallel_loop_access !1
  %y_increment = add nuw nsw i64 %y, 1
  %y_postcondition = icmp eq i64 %y_increment, %9
  br i1 %y_postcondition, label %y_exit, label %y_body

y_exit:                                           ; preds = %y_body
  ret void
}

declare void @likely_fork(i8* noalias nocapture, i8* noalias nocapture, i64)

define %f32XY* @convert_grayscale(%f32CXY*) {
entry:
  %1 = getelementptr inbounds %f32CXY, %f32CXY* %0, i64 0, i32 3
  %columns = load i32, i32* %1, align 4, !range !0
  %2 = getelementptr inbounds %f32CXY, %f32CXY* %0, i64 0, i32 4
  %rows = load i32, i32* %2, align 4, !range !0
  %3 = call %u0CXYT* @likely_new(i32 24864, i32 1, i32 %columns, i32 %rows, i32 1, i8* null)
  %dst = bitcast %u0CXYT* %3 to %f32XY*
  %4 = zext i32 %rows to i64
  %5 = alloca { %f32XY*, %f32CXY* }, align 8
  %6 = bitcast { %f32XY*, %f32CXY* }* %5 to %u0CXYT**
  store %u0CXYT* %3, %u0CXYT** %6, align 8
  %7 = getelementptr inbounds { %f32XY*, %f32CXY* }, { %f32XY*, %f32CXY* }* %5, i64 0, i32 1
  store %f32CXY* %0, %f32CXY** %7, align 8
  %8 = bitcast { %f32XY*, %f32CXY* }* %5 to i8*
  call void @likely_fork(i8* bitcast (void ({ %f32XY*, %f32CXY* }*, i64, i64)* @convert_grayscale_tmp_thunk0 to i8*), i8* %8, i64 %4)
  ret %f32XY* %dst
}

attributes #0 = { nounwind }
attributes #1 = { argmemonly nounwind }
attributes #2 = { norecurse nounwind }

!0 = !{i32 1, i32 -1}
!1 = distinct !{!1}
