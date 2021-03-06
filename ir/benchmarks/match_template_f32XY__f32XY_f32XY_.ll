; ModuleID = 'likely'
source_filename = "likely"

%u0Matrix = type { i32, i32, i32, i32, i32, i32, [0 x i8] }
%f32Matrix = type { i32, i32, i32, i32, i32, i32, [0 x float] }

; Function Attrs: argmemonly nounwind
declare noalias %u0Matrix* @likely_new(i32 zeroext, i32 zeroext, i32 zeroext, i32 zeroext, i32 zeroext, i8* noalias nocapture) #0

; Function Attrs: nounwind
define noalias %f32Matrix* @match_template(%f32Matrix* noalias nocapture readonly, %f32Matrix* noalias nocapture readonly) #1 {
entry:
  %2 = getelementptr inbounds %f32Matrix, %f32Matrix* %1, i64 0, i32 3
  %width = load i32, i32* %2, align 4, !range !0
  %3 = getelementptr inbounds %f32Matrix, %f32Matrix* %1, i64 0, i32 4
  %height = load i32, i32* %3, align 4, !range !0
  %4 = getelementptr inbounds %f32Matrix, %f32Matrix* %0, i64 0, i32 3
  %columns = load i32, i32* %4, align 4, !range !0
  %5 = sub i32 %columns, %width
  %6 = add nuw nsw i32 %5, 1
  %7 = getelementptr inbounds %f32Matrix, %f32Matrix* %0, i64 0, i32 4
  %rows = load i32, i32* %7, align 4, !range !0
  %8 = sub i32 %rows, %height
  %9 = add nuw nsw i32 %8, 1
  %10 = call %u0Matrix* @likely_new(i32 24864, i32 1, i32 %6, i32 %9, i32 1, i8* null)
  %11 = zext i32 %9 to i64
  %dst_y_step = zext i32 %6 to i64
  %12 = getelementptr inbounds %u0Matrix, %u0Matrix* %10, i64 1
  %13 = bitcast %u0Matrix* %12 to float*
  %src_y_step = zext i32 %columns to i64
  %templ_y_step = zext i32 %width to i64
  br label %y_body

y_body:                                           ; preds = %x_exit, %entry
  %y = phi i64 [ 0, %entry ], [ %y_increment, %x_exit ]
  %14 = mul nuw nsw i64 %y, %dst_y_step
  br label %x_body

x_body:                                           ; preds = %y_body, %exit
  %x = phi i64 [ %x_increment, %exit ], [ 0, %y_body ]
  br label %loop9.preheader

loop9.preheader:                                  ; preds = %x_body, %exit11
  %15 = phi i32 [ %35, %exit11 ], [ 0, %x_body ]
  %16 = phi float [ %32, %exit11 ], [ 0.000000e+00, %x_body ]
  %17 = zext i32 %15 to i64
  %18 = add nuw nsw i64 %17, %y
  %19 = mul nuw nsw i64 %18, %src_y_step
  %20 = add i64 %19, %x
  %21 = mul nuw nsw i64 %17, %templ_y_step
  br label %true_entry10

true_entry10:                                     ; preds = %loop9.preheader, %true_entry10
  %22 = phi float [ %32, %true_entry10 ], [ %16, %loop9.preheader ]
  %23 = phi i32 [ %33, %true_entry10 ], [ 0, %loop9.preheader ]
  %24 = zext i32 %23 to i64
  %25 = add i64 %20, %24
  %26 = getelementptr %f32Matrix, %f32Matrix* %0, i64 0, i32 6, i64 %25
  %27 = load float, float* %26, align 4, !llvm.mem.parallel_loop_access !1
  %28 = add nuw nsw i64 %24, %21
  %29 = getelementptr %f32Matrix, %f32Matrix* %1, i64 0, i32 6, i64 %28
  %30 = load float, float* %29, align 4, !llvm.mem.parallel_loop_access !1
  %31 = fmul fast float %30, %27
  %32 = fadd fast float %31, %22
  %33 = add nuw nsw i32 %23, 1
  %34 = icmp eq i32 %33, %width
  br i1 %34, label %exit11, label %true_entry10

exit11:                                           ; preds = %true_entry10
  %35 = add nuw nsw i32 %15, 1
  %36 = icmp eq i32 %35, %height
  br i1 %36, label %exit, label %loop9.preheader

exit:                                             ; preds = %exit11
  %37 = add nuw nsw i64 %x, %14
  %38 = getelementptr float, float* %13, i64 %37
  store float %32, float* %38, align 4, !llvm.mem.parallel_loop_access !1
  %x_increment = add nuw nsw i64 %x, 1
  %x_postcondition = icmp eq i64 %x_increment, %dst_y_step
  br i1 %x_postcondition, label %x_exit, label %x_body

x_exit:                                           ; preds = %exit
  %y_increment = add nuw nsw i64 %y, 1
  %y_postcondition = icmp eq i64 %y_increment, %11
  br i1 %y_postcondition, label %y_exit, label %y_body

y_exit:                                           ; preds = %x_exit
  %dst = bitcast %u0Matrix* %10 to %f32Matrix*
  ret %f32Matrix* %dst
}

attributes #0 = { argmemonly nounwind }
attributes #1 = { nounwind }

!0 = !{i32 1, i32 -1}
!1 = distinct !{!1}
