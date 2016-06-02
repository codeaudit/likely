; ModuleID = 'likely'

%u0CXYT = type { i32, i32, i32, i32, i32, i32, [0 x i8] }
%f32CXY = type { i32, i32, i32, i32, i32, i32, [0 x float] }

; Function Attrs: argmemonly nounwind
declare noalias %u0CXYT* @likely_new(i32 zeroext, i32 zeroext, i32 zeroext, i32 zeroext, i32 zeroext, i8* noalias nocapture) #0

; Function Attrs: norecurse nounwind
define private void @multiply_add_tmp_thunk0({ %f32CXY*, %f32CXY*, float, float }* noalias nocapture readonly, i64, i64) #1 {
entry:
  %3 = getelementptr inbounds { %f32CXY*, %f32CXY*, float, float }, { %f32CXY*, %f32CXY*, float, float }* %0, i64 0, i32 0
  %4 = load %f32CXY*, %f32CXY** %3, align 8
  %5 = getelementptr inbounds { %f32CXY*, %f32CXY*, float, float }, { %f32CXY*, %f32CXY*, float, float }* %0, i64 0, i32 1
  %6 = load %f32CXY*, %f32CXY** %5, align 8
  %7 = getelementptr inbounds { %f32CXY*, %f32CXY*, float, float }, { %f32CXY*, %f32CXY*, float, float }* %0, i64 0, i32 2
  %8 = load float, float* %7, align 4
  %9 = getelementptr inbounds { %f32CXY*, %f32CXY*, float, float }, { %f32CXY*, %f32CXY*, float, float }* %0, i64 0, i32 3
  %10 = load float, float* %9, align 4
  %11 = getelementptr inbounds %f32CXY, %f32CXY* %6, i64 0, i32 2
  %channels1 = load i32, i32* %11, align 4, !range !0
  %dst_c = zext i32 %channels1 to i64
  %12 = getelementptr inbounds %f32CXY, %f32CXY* %6, i64 0, i32 3
  %columns2 = load i32, i32* %12, align 4, !range !0
  %dst_x = zext i32 %columns2 to i64
  %13 = mul i64 %dst_c, %2
  %14 = mul i64 %13, %dst_x
  br label %y_body

y_body:                                           ; preds = %y_body, %entry
  %y = phi i64 [ %1, %entry ], [ %y_increment, %y_body ]
  %15 = getelementptr %f32CXY, %f32CXY* %6, i64 0, i32 6, i64 %y
  %16 = load float, float* %15, align 4, !llvm.mem.parallel_loop_access !1
  %17 = fmul fast float %16, %8
  %val = fadd fast float %17, %10
  %18 = getelementptr %f32CXY, %f32CXY* %4, i64 0, i32 6, i64 %y
  store float %val, float* %18, align 4, !llvm.mem.parallel_loop_access !1
  %y_increment = add nuw nsw i64 %y, 1
  %y_postcondition = icmp eq i64 %y_increment, %14
  br i1 %y_postcondition, label %y_exit, label %y_body

y_exit:                                           ; preds = %y_body
  ret void
}

declare void @likely_fork(i8* noalias nocapture, i8* noalias nocapture, i64)

define %f32CXY* @multiply_add(%f32CXY*, float, float) {
entry:
  %3 = getelementptr inbounds %f32CXY, %f32CXY* %0, i64 0, i32 2
  %channels = load i32, i32* %3, align 4, !range !0
  %4 = getelementptr inbounds %f32CXY, %f32CXY* %0, i64 0, i32 3
  %columns = load i32, i32* %4, align 4, !range !0
  %5 = getelementptr inbounds %f32CXY, %f32CXY* %0, i64 0, i32 4
  %rows = load i32, i32* %5, align 4, !range !0
  %6 = call %u0CXYT* @likely_new(i32 28960, i32 %channels, i32 %columns, i32 %rows, i32 1, i8* null)
  %dst = bitcast %u0CXYT* %6 to %f32CXY*
  %7 = zext i32 %rows to i64
  %8 = alloca { %f32CXY*, %f32CXY*, float, float }, align 8
  %9 = bitcast { %f32CXY*, %f32CXY*, float, float }* %8 to %u0CXYT**
  store %u0CXYT* %6, %u0CXYT** %9, align 8
  %10 = getelementptr inbounds { %f32CXY*, %f32CXY*, float, float }, { %f32CXY*, %f32CXY*, float, float }* %8, i64 0, i32 1
  store %f32CXY* %0, %f32CXY** %10, align 8
  %11 = getelementptr inbounds { %f32CXY*, %f32CXY*, float, float }, { %f32CXY*, %f32CXY*, float, float }* %8, i64 0, i32 2
  store float %1, float* %11, align 8
  %12 = getelementptr inbounds { %f32CXY*, %f32CXY*, float, float }, { %f32CXY*, %f32CXY*, float, float }* %8, i64 0, i32 3
  store float %2, float* %12, align 4
  %13 = bitcast { %f32CXY*, %f32CXY*, float, float }* %8 to i8*
  call void @likely_fork(i8* bitcast (void ({ %f32CXY*, %f32CXY*, float, float }*, i64, i64)* @multiply_add_tmp_thunk0 to i8*), i8* %13, i64 %7)
  ret %f32CXY* %dst
}

attributes #0 = { argmemonly nounwind }
attributes #1 = { norecurse nounwind }

!0 = !{i32 1, i32 -1}
!1 = distinct !{!1}
