; ModuleID = 'likely'
source_filename = "likely"

%u0Matrix = type { i32, i32, i32, i32, i32, i32, [0 x i8] }
%f32Matrix = type { i32, i32, i32, i32, i32, i32, [0 x float] }

; Function Attrs: nounwind
declare void @llvm.assume(i1) #0

; Function Attrs: argmemonly nounwind
declare noalias %u0Matrix* @likely_new(i32 zeroext, i32 zeroext, i32 zeroext, i32 zeroext, i32 zeroext, i8* noalias nocapture) #1

; Function Attrs: nounwind
define noalias %f32Matrix* @filter_2D(%f32Matrix* noalias nocapture readonly, %f32Matrix* noalias nocapture readonly) #0 {
entry:
  br label %entry.split

entry.split:                                      ; preds = %entry
  %2 = getelementptr inbounds %f32Matrix, %f32Matrix* %1, i64 0, i32 3
  %width = load i32, i32* %2, align 4, !range !0
  %3 = getelementptr inbounds %f32Matrix, %f32Matrix* %1, i64 0, i32 4
  %height = load i32, i32* %3, align 4, !range !0
  %4 = srem i32 %width, 2
  %5 = icmp eq i32 %4, 1
  call void @llvm.assume(i1 %5)
  %6 = srem i32 %height, 2
  %7 = icmp eq i32 %6, 1
  call void @llvm.assume(i1 %7)
  %8 = getelementptr inbounds %f32Matrix, %f32Matrix* %0, i64 0, i32 3
  %columns = load i32, i32* %8, align 4, !range !0
  %9 = add i32 %width, -1
  %10 = add nuw nsw i32 %columns, %9
  %11 = getelementptr inbounds %f32Matrix, %f32Matrix* %0, i64 0, i32 4
  %rows = load i32, i32* %11, align 4, !range !0
  %12 = add i32 %height, -1
  %13 = add nuw nsw i32 %rows, %12
  %14 = call %u0Matrix* @likely_new(i32 24864, i32 1, i32 %10, i32 %13, i32 1, i8* null)
  %15 = zext i32 %13 to i64
  %mat_y_step = zext i32 %10 to i64
  %16 = getelementptr inbounds %u0Matrix, %u0Matrix* %14, i64 1
  %scevgep7 = getelementptr %u0Matrix, %u0Matrix* %14, i64 1, i32 0
  %17 = shl nuw nsw i64 %mat_y_step, 2
  br label %y_body

y_body:                                           ; preds = %y_body, %entry.split
  %y = phi i64 [ 0, %entry.split ], [ %y_increment, %y_body ]
  %18 = mul i64 %y, %mat_y_step
  %scevgep8 = getelementptr i32, i32* %scevgep7, i64 %18
  %scevgep89 = bitcast i32* %scevgep8 to i8*
  call void @llvm.memset.p0i8.i64(i8* %scevgep89, i8 0, i64 %17, i32 4, i1 false)
  %y_increment = add nuw nsw i64 %y, 1
  %y_postcondition = icmp eq i64 %y_increment, %15
  br i1 %y_postcondition, label %y_exit, label %y_body

y_exit:                                           ; preds = %y_body
  %19 = bitcast %u0Matrix* %16 to float*
  %pad-columns = sdiv i32 %9, 2
  %pad-rows = sdiv i32 %12, 2
  %20 = zext i32 %rows to i64
  %src_y_step = zext i32 %columns to i64
  %21 = sext i32 %pad-rows to i64
  %22 = sext i32 %pad-columns to i64
  %scevgep4 = getelementptr %f32Matrix, %f32Matrix* %0, i64 1, i32 0
  %23 = shl nuw nsw i64 %src_y_step, 2
  br label %y_body9

y_body9:                                          ; preds = %y_body9, %y_exit
  %y11 = phi i64 [ 0, %y_exit ], [ %y_increment17, %y_body9 ]
  %tmp = add i64 %y11, %21
  %tmp10 = mul i64 %tmp, %mat_y_step
  %24 = add i64 %tmp10, %22
  %scevgep2 = getelementptr i32, i32* %scevgep7, i64 %24
  %scevgep23 = bitcast i32* %scevgep2 to i8*
  %25 = mul i64 %y11, %src_y_step
  %scevgep5 = getelementptr i32, i32* %scevgep4, i64 %25
  %scevgep56 = bitcast i32* %scevgep5 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %scevgep23, i8* %scevgep56, i64 %23, i32 4, i1 false)
  %y_increment17 = add nuw nsw i64 %y11, 1
  %y_postcondition18 = icmp eq i64 %y_increment17, %20
  br i1 %y_postcondition18, label %y_exit10, label %y_body9

y_exit10:                                         ; preds = %y_body9
  %26 = call %u0Matrix* @likely_new(i32 24864, i32 1, i32 %columns, i32 %rows, i32 1, i8* null)
  %27 = getelementptr inbounds %u0Matrix, %u0Matrix* %26, i64 1
  %28 = bitcast %u0Matrix* %27 to float*
  %kernel_y_step = zext i32 %width to i64
  br label %y_body31

y_body31:                                         ; preds = %x_exit35, %y_exit10
  %y33 = phi i64 [ 0, %y_exit10 ], [ %y_increment43, %x_exit35 ]
  %29 = mul nuw nsw i64 %y33, %src_y_step
  br label %x_body34

x_body34:                                         ; preds = %y_body31, %exit
  %x36 = phi i64 [ %x_increment41, %exit ], [ 0, %y_body31 ]
  %30 = add nuw nsw i64 %x36, %29
  br label %loop38.preheader

loop38.preheader:                                 ; preds = %x_body34, %exit40
  %31 = phi i32 [ %51, %exit40 ], [ 0, %x_body34 ]
  %32 = phi float [ %48, %exit40 ], [ 0.000000e+00, %x_body34 ]
  %33 = zext i32 %31 to i64
  %34 = add nuw nsw i64 %33, %y33
  %35 = mul nuw nsw i64 %34, %mat_y_step
  %36 = add i64 %35, %x36
  %37 = mul nuw nsw i64 %33, %kernel_y_step
  br label %true_entry39

true_entry39:                                     ; preds = %loop38.preheader, %true_entry39
  %38 = phi float [ %48, %true_entry39 ], [ %32, %loop38.preheader ]
  %39 = phi i32 [ %49, %true_entry39 ], [ 0, %loop38.preheader ]
  %40 = zext i32 %39 to i64
  %41 = add i64 %36, %40
  %42 = getelementptr float, float* %19, i64 %41
  %43 = load float, float* %42, align 4, !llvm.mem.parallel_loop_access !1
  %44 = add nuw nsw i64 %40, %37
  %45 = getelementptr %f32Matrix, %f32Matrix* %1, i64 0, i32 6, i64 %44
  %46 = load float, float* %45, align 4, !llvm.mem.parallel_loop_access !1
  %47 = fmul fast float %46, %43
  %48 = fadd fast float %47, %38
  %49 = add nuw nsw i32 %39, 1
  %50 = icmp eq i32 %49, %width
  br i1 %50, label %exit40, label %true_entry39

exit40:                                           ; preds = %true_entry39
  %51 = add nuw nsw i32 %31, 1
  %52 = icmp eq i32 %51, %height
  br i1 %52, label %exit, label %loop38.preheader

exit:                                             ; preds = %exit40
  %53 = getelementptr float, float* %28, i64 %30
  store float %48, float* %53, align 4, !llvm.mem.parallel_loop_access !1
  %x_increment41 = add nuw nsw i64 %x36, 1
  %x_postcondition42 = icmp eq i64 %x_increment41, %src_y_step
  br i1 %x_postcondition42, label %x_exit35, label %x_body34

x_exit35:                                         ; preds = %exit
  %y_increment43 = add nuw nsw i64 %y33, 1
  %y_postcondition44 = icmp eq i64 %y_increment43, %20
  br i1 %y_postcondition44, label %y_exit32, label %y_body31

y_exit32:                                         ; preds = %x_exit35
  %dst = bitcast %u0Matrix* %26 to %f32Matrix*
  %54 = bitcast %u0Matrix* %14 to i8*
  call void @likely_release_mat(i8* %54) #0
  ret %f32Matrix* %dst
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i32, i1) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i32, i1) #1

declare void @likely_release_mat(i8* noalias nocapture)

attributes #0 = { nounwind }
attributes #1 = { argmemonly nounwind }

!0 = !{i32 1, i32 -1}
!1 = distinct !{!1}
