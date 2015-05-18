; ModuleID = 'likely'

%u0CXYT = type { i32, i32, i32, i32, i32, i32, [0 x i8] }
%f32XY = type { i32, i32, i32, i32, i32, i32, [0 x float] }

; Function Attrs: nounwind
declare void @llvm.assume(i1) #0

; Function Attrs: nounwind readonly
declare noalias %u0CXYT* @likely_new(i32 zeroext, i32 zeroext, i32 zeroext, i32 zeroext, i32 zeroext, i8* noalias nocapture) #1

; Function Attrs: nounwind
define private void @matrix_multiplication_tmp_thunk0({ %f32XY*, %f32XY*, %f32XY*, i32 }* noalias nocapture readonly, i64, i64) #0 {
entry:
  %3 = getelementptr inbounds { %f32XY*, %f32XY*, %f32XY*, i32 }, { %f32XY*, %f32XY*, %f32XY*, i32 }* %0, i64 0, i32 0
  %4 = load %f32XY*, %f32XY** %3, align 8
  %5 = getelementptr inbounds { %f32XY*, %f32XY*, %f32XY*, i32 }, { %f32XY*, %f32XY*, %f32XY*, i32 }* %0, i64 0, i32 1
  %6 = load %f32XY*, %f32XY** %5, align 8
  %7 = getelementptr inbounds { %f32XY*, %f32XY*, %f32XY*, i32 }, { %f32XY*, %f32XY*, %f32XY*, i32 }* %0, i64 0, i32 2
  %8 = load %f32XY*, %f32XY** %7, align 8
  %9 = getelementptr inbounds { %f32XY*, %f32XY*, %f32XY*, i32 }, { %f32XY*, %f32XY*, %f32XY*, i32 }* %0, i64 0, i32 3
  %10 = load i32, i32* %9, align 4
  %11 = getelementptr inbounds %f32XY, %f32XY* %8, i64 0, i32 3
  %columns3 = load i32, i32* %11, align 4, !range !0
  %C_y_step = zext i32 %columns3 to i64
  %12 = getelementptr inbounds %f32XY, %f32XY* %4, i64 0, i32 6, i64 0
  %13 = ptrtoint float* %12 to i64
  %14 = and i64 %13, 31
  %15 = icmp eq i64 %14, 0
  call void @llvm.assume(i1 %15)
  %16 = getelementptr inbounds %f32XY, %f32XY* %6, i64 0, i32 3
  %columns1 = load i32, i32* %16, align 4, !range !0
  %A_y_step = zext i32 %columns1 to i64
  %17 = getelementptr inbounds %f32XY, %f32XY* %6, i64 0, i32 6, i64 0
  %18 = ptrtoint float* %17 to i64
  %19 = and i64 %18, 31
  %20 = icmp eq i64 %19, 0
  call void @llvm.assume(i1 %20)
  %21 = getelementptr inbounds %f32XY, %f32XY* %8, i64 0, i32 6, i64 0
  %22 = ptrtoint float* %21 to i64
  %23 = and i64 %22, 31
  %24 = icmp eq i64 %23, 0
  call void @llvm.assume(i1 %24)
  %25 = icmp eq i32 %10, 0
  br label %y_body

y_body:                                           ; preds = %x_exit, %entry
  %y = phi i64 [ %1, %entry ], [ %y_increment, %x_exit ]
  %26 = mul nuw nsw i64 %y, %C_y_step
  %27 = mul nuw nsw i64 %y, %A_y_step
  br label %x_body

x_body:                                           ; preds = %exit, %y_body
  %x = phi i64 [ 0, %y_body ], [ %x_increment, %exit ]
  br i1 %25, label %exit, label %true_enry

true_enry:                                        ; preds = %x_body, %true_enry
  %28 = phi i32 [ %42, %true_enry ], [ 0, %x_body ]
  %29 = phi double [ %41, %true_enry ], [ 0.000000e+00, %x_body ]
  %30 = sext i32 %28 to i64
  %31 = add nuw nsw i64 %30, %27
  %32 = getelementptr %f32XY, %f32XY* %6, i64 0, i32 6, i64 %31
  %33 = load float, float* %32, align 4, !llvm.mem.parallel_loop_access !1
  %34 = fpext float %33 to double
  %35 = mul nuw nsw i64 %30, %C_y_step
  %36 = add nuw nsw i64 %35, %x
  %37 = getelementptr %f32XY, %f32XY* %8, i64 0, i32 6, i64 %36
  %38 = load float, float* %37, align 4, !llvm.mem.parallel_loop_access !1
  %39 = fpext float %38 to double
  %40 = fmul fast double %39, %34
  %41 = fadd fast double %40, %29
  %42 = add nuw nsw i32 %28, 1
  %43 = icmp eq i32 %42, %10
  br i1 %43, label %exit, label %true_enry

exit:                                             ; preds = %true_enry, %x_body
  %.lcssa = phi double [ 0.000000e+00, %x_body ], [ %41, %true_enry ]
  %44 = fptrunc double %.lcssa to float
  %45 = add nuw nsw i64 %x, %26
  %46 = getelementptr %f32XY, %f32XY* %4, i64 0, i32 6, i64 %45
  store float %44, float* %46, align 4, !llvm.mem.parallel_loop_access !1
  %x_increment = add nuw nsw i64 %x, 1
  %x_postcondition = icmp eq i64 %x_increment, %C_y_step
  br i1 %x_postcondition, label %x_exit, label %x_body, !llvm.loop !1

x_exit:                                           ; preds = %exit
  %y_increment = add nuw nsw i64 %y, 1
  %y_postcondition = icmp eq i64 %y_increment, %2
  br i1 %y_postcondition, label %y_exit, label %y_body

y_exit:                                           ; preds = %x_exit
  ret void
}

declare void @likely_fork(i8* noalias nocapture, i8* noalias nocapture, i64)

define %f32XY* @matrix_multiplication(%f32XY*, %f32XY*) {
entry:
  %2 = getelementptr inbounds %f32XY, %f32XY* %1, i64 0, i32 4
  %rows = load i32, i32* %2, align 4, !range !0
  %3 = getelementptr inbounds %f32XY, %f32XY* %0, i64 0, i32 3
  %columns = load i32, i32* %3, align 4, !range !0
  %4 = icmp eq i32 %rows, %columns
  call void @llvm.assume(i1 %4)
  %5 = getelementptr inbounds %f32XY, %f32XY* %1, i64 0, i32 3
  %columns1 = load i32, i32* %5, align 4, !range !0
  %6 = getelementptr inbounds %f32XY, %f32XY* %0, i64 0, i32 4
  %rows2 = load i32, i32* %6, align 4, !range !0
  %7 = call %u0CXYT* @likely_new(i32 24864, i32 1, i32 %columns1, i32 %rows2, i32 1, i8* null)
  %8 = bitcast %u0CXYT* %7 to %f32XY*
  %9 = zext i32 %rows2 to i64
  %10 = alloca { %f32XY*, %f32XY*, %f32XY*, i32 }, align 8
  %11 = bitcast { %f32XY*, %f32XY*, %f32XY*, i32 }* %10 to %u0CXYT**
  store %u0CXYT* %7, %u0CXYT** %11, align 8
  %12 = getelementptr inbounds { %f32XY*, %f32XY*, %f32XY*, i32 }, { %f32XY*, %f32XY*, %f32XY*, i32 }* %10, i64 0, i32 1
  store %f32XY* %0, %f32XY** %12, align 8
  %13 = getelementptr inbounds { %f32XY*, %f32XY*, %f32XY*, i32 }, { %f32XY*, %f32XY*, %f32XY*, i32 }* %10, i64 0, i32 2
  store %f32XY* %1, %f32XY** %13, align 8
  %14 = getelementptr inbounds { %f32XY*, %f32XY*, %f32XY*, i32 }, { %f32XY*, %f32XY*, %f32XY*, i32 }* %10, i64 0, i32 3
  store i32 %columns, i32* %14, align 8
  %15 = bitcast { %f32XY*, %f32XY*, %f32XY*, i32 }* %10 to i8*
  call void @likely_fork(i8* bitcast (void ({ %f32XY*, %f32XY*, %f32XY*, i32 }*, i64, i64)* @matrix_multiplication_tmp_thunk0 to i8*), i8* %15, i64 %9)
  ret %f32XY* %8
}

attributes #0 = { nounwind }
attributes #1 = { nounwind readonly }

!0 = !{i32 1, i32 -1}
!1 = distinct !{!1}
