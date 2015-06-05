; ModuleID = 'likely'

%u8SXY = type { i32, i32, i32, i32, i32, i32, [0 x i8] }

; Function Attrs: nounwind
declare void @llvm.assume(i1) #0

define %u8SXY* @sort(%u8SXY*) {
entry:
  %1 = getelementptr inbounds %u8SXY, %u8SXY* %0, i64 0, i32 4
  %len = load i32, i32* %1, align 4, !range !0
  %2 = zext i32 %len to i64
  %3 = getelementptr inbounds %u8SXY, %u8SXY* %0, i64 0, i32 3
  %columns = load i32, i32* %3, align 4, !range !0
  %src_y_step = zext i32 %columns to i64
  %4 = getelementptr inbounds %u8SXY, %u8SXY* %0, i64 0, i32 6, i64 0
  %5 = ptrtoint i8* %4 to i64
  %6 = and i64 %5, 31
  %7 = icmp eq i64 %6, 0
  call void @llvm.assume(i1 %7)
  br label %y_body

y_body:                                           ; preds = %exit, %entry
  %y = phi i64 [ 0, %entry ], [ %y_increment, %exit ]
  %8 = mul nuw nsw i64 %y, %src_y_step
  br label %true_entry

true_entry:                                       ; preds = %y_body, %loop.backedge
  %9 = phi i32 [ %14, %loop.backedge ], [ 0, %y_body ]
  %10 = sext i32 %9 to i64
  %11 = add nuw nsw i64 %10, %8
  %12 = getelementptr %u8SXY, %u8SXY* %0, i64 0, i32 6, i64 %11
  %13 = load i8, i8* %12, align 1, !llvm.mem.parallel_loop_access !1
  %14 = add nuw nsw i32 %9, 1
  %15 = icmp eq i32 %14, %len
  br i1 %15, label %exit5, label %true_entry4

exit:                                             ; preds = %loop.backedge
  %y_increment = add nuw nsw i64 %y, 1
  %y_postcondition = icmp eq i64 %y_increment, %2
  br i1 %y_postcondition, label %y_exit, label %y_body

y_exit:                                           ; preds = %exit
  %16 = bitcast %u8SXY* %0 to i8*
  %17 = call i8* @likely_retain_mat(i8* %16)
  %18 = bitcast i8* %17 to %u8SXY*
  ret %u8SXY* %18

true_entry4:                                      ; preds = %true_entry, %true_entry4
  %19 = phi i32 [ %26, %true_entry4 ], [ %14, %true_entry ]
  %20 = phi i32 [ %., %true_entry4 ], [ %9, %true_entry ]
  %21 = phi i8 [ %element., %true_entry4 ], [ %13, %true_entry ]
  %22 = sext i32 %19 to i64
  %23 = add nuw nsw i64 %22, %8
  %24 = getelementptr %u8SXY, %u8SXY* %0, i64 0, i32 6, i64 %23
  %element = load i8, i8* %24, align 1, !llvm.mem.parallel_loop_access !1
  %25 = icmp ult i8 %element, %21
  %element. = select i1 %25, i8 %element, i8 %21
  %. = select i1 %25, i32 %19, i32 %20
  %26 = add nuw nsw i32 %19, 1
  %27 = icmp eq i32 %26, %len
  br i1 %27, label %exit5, label %true_entry4

exit5:                                            ; preds = %true_entry4, %true_entry
  %.lcssa = phi i32 [ %9, %true_entry ], [ %., %true_entry4 ]
  %28 = icmp eq i32 %9, %.lcssa
  br i1 %28, label %loop.backedge, label %true_entry8

loop.backedge:                                    ; preds = %exit5, %true_entry8
  br i1 %15, label %exit, label %true_entry

true_entry8:                                      ; preds = %exit5
  %29 = sext i32 %.lcssa to i64
  %30 = add nuw nsw i64 %29, %8
  %31 = getelementptr %u8SXY, %u8SXY* %0, i64 0, i32 6, i64 %30
  %32 = load i8, i8* %31, align 1, !llvm.mem.parallel_loop_access !1
  store i8 %32, i8* %12, align 1, !llvm.mem.parallel_loop_access !1
  store i8 %13, i8* %31, align 1, !llvm.mem.parallel_loop_access !1
  br label %loop.backedge
}

declare i8* @likely_retain_mat(i8* noalias nocapture)

attributes #0 = { nounwind }

!0 = !{i32 1, i32 -1}
!1 = distinct !{!1}
