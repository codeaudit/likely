; ModuleID = 'likely'

%u0CXYT = type { i32, i32, i32, i32, i32, i32, [0 x i8] }
%u8SCXY = type { i32, i32, i32, i32, i32, i32, [0 x i8] }

; Function Attrs: nounwind readonly
declare noalias %u0CXYT* @likely_new(i32 zeroext, i32 zeroext, i32 zeroext, i32 zeroext, i32 zeroext, i8* noalias nocapture) #0

; Function Attrs: nounwind
define private void @binary_threshold_tmp_thunk0({ %u8SCXY*, %u8SCXY*, i8, i8 }* noalias nocapture readonly, i64, i64) #1 {
entry:
  %3 = getelementptr inbounds { %u8SCXY*, %u8SCXY*, i8, i8 }, { %u8SCXY*, %u8SCXY*, i8, i8 }* %0, i64 0, i32 0
  %4 = load %u8SCXY*, %u8SCXY** %3, align 8
  %5 = getelementptr inbounds { %u8SCXY*, %u8SCXY*, i8, i8 }, { %u8SCXY*, %u8SCXY*, i8, i8 }* %0, i64 0, i32 1
  %6 = load %u8SCXY*, %u8SCXY** %5, align 8
  %7 = getelementptr inbounds { %u8SCXY*, %u8SCXY*, i8, i8 }, { %u8SCXY*, %u8SCXY*, i8, i8 }* %0, i64 0, i32 2
  %8 = load i8, i8* %7, align 1
  %9 = getelementptr inbounds { %u8SCXY*, %u8SCXY*, i8, i8 }, { %u8SCXY*, %u8SCXY*, i8, i8 }* %0, i64 0, i32 3
  %10 = load i8, i8* %9, align 1
  %11 = getelementptr inbounds %u8SCXY, %u8SCXY* %4, i64 0, i32 2
  %channels = load i32, i32* %11, align 4, !range !0
  %dst_c = zext i32 %channels to i64
  %12 = getelementptr inbounds %u8SCXY, %u8SCXY* %4, i64 0, i32 3
  %columns = load i32, i32* %12, align 4, !range !0
  %dst_x = zext i32 %columns to i64
  %13 = getelementptr inbounds %u8SCXY, %u8SCXY* %4, i64 0, i32 6, i64 0
  %14 = ptrtoint i8* %13 to i64
  %15 = and i64 %14, 31
  %16 = icmp eq i64 %15, 0
  tail call void @llvm.assume(i1 %16)
  %17 = getelementptr inbounds %u8SCXY, %u8SCXY* %6, i64 0, i32 2
  %channels1 = load i32, i32* %17, align 4, !range !0
  %src_c = zext i32 %channels1 to i64
  %18 = getelementptr inbounds %u8SCXY, %u8SCXY* %6, i64 0, i32 3
  %columns2 = load i32, i32* %18, align 4, !range !0
  %src_x = zext i32 %columns2 to i64
  %19 = getelementptr inbounds %u8SCXY, %u8SCXY* %6, i64 0, i32 6, i64 0
  %20 = ptrtoint i8* %19 to i64
  %21 = and i64 %20, 31
  %22 = icmp eq i64 %21, 0
  tail call void @llvm.assume(i1 %22)
  br label %y_body

y_body:                                           ; preds = %x_exit, %entry
  %y = phi i64 [ %1, %entry ], [ %y_increment, %x_exit ]
  %23 = mul i64 %y, %src_x
  %24 = mul i64 %y, %dst_x
  br label %x_body

x_body:                                           ; preds = %c_exit, %y_body
  %x = phi i64 [ 0, %y_body ], [ %x_increment, %c_exit ]
  %tmp = add i64 %x, %23
  %tmp4 = mul i64 %tmp, %src_c
  %tmp5 = add i64 %x, %24
  %tmp6 = mul i64 %tmp5, %dst_c
  br label %c_body

c_body:                                           ; preds = %c_body, %x_body
  %c = phi i64 [ 0, %x_body ], [ %c_increment, %c_body ]
  %25 = add i64 %tmp4, %c
  %26 = getelementptr %u8SCXY, %u8SCXY* %6, i64 0, i32 6, i64 %25
  %27 = load i8, i8* %26, align 1, !llvm.mem.parallel_loop_access !1
  %28 = icmp ugt i8 %27, %8
  %. = select i1 %28, i8 %10, i8 0
  %29 = add i64 %tmp6, %c
  %30 = getelementptr %u8SCXY, %u8SCXY* %4, i64 0, i32 6, i64 %29
  store i8 %., i8* %30, align 1, !llvm.mem.parallel_loop_access !1
  %c_increment = add nuw nsw i64 %c, 1
  %c_postcondition = icmp eq i64 %c_increment, %dst_c
  br i1 %c_postcondition, label %c_exit, label %c_body, !llvm.loop !1

c_exit:                                           ; preds = %c_body
  %x_increment = add nuw nsw i64 %x, 1
  %x_postcondition = icmp eq i64 %x_increment, %dst_x
  br i1 %x_postcondition, label %x_exit, label %x_body

x_exit:                                           ; preds = %c_exit
  %y_increment = add nuw nsw i64 %y, 1
  %y_postcondition = icmp eq i64 %y_increment, %2
  br i1 %y_postcondition, label %y_exit, label %y_body

y_exit:                                           ; preds = %x_exit
  ret void
}

; Function Attrs: nounwind
declare void @llvm.assume(i1) #1

declare void @likely_fork(i8* noalias nocapture, i8* noalias nocapture, i64)

define %u8SCXY* @binary_threshold(%u8SCXY*, i8, i8) {
entry:
  %3 = getelementptr inbounds %u8SCXY, %u8SCXY* %0, i64 0, i32 2
  %channels = load i32, i32* %3, align 4, !range !0
  %4 = getelementptr inbounds %u8SCXY, %u8SCXY* %0, i64 0, i32 3
  %columns = load i32, i32* %4, align 4, !range !0
  %5 = getelementptr inbounds %u8SCXY, %u8SCXY* %0, i64 0, i32 4
  %rows = load i32, i32* %5, align 4, !range !0
  %6 = tail call %u0CXYT* @likely_new(i32 29704, i32 %channels, i32 %columns, i32 %rows, i32 1, i8* null)
  %7 = bitcast %u0CXYT* %6 to %u8SCXY*
  %8 = zext i32 %rows to i64
  %9 = alloca { %u8SCXY*, %u8SCXY*, i8, i8 }, align 8
  %10 = bitcast { %u8SCXY*, %u8SCXY*, i8, i8 }* %9 to %u0CXYT**
  store %u0CXYT* %6, %u0CXYT** %10, align 8
  %11 = getelementptr inbounds { %u8SCXY*, %u8SCXY*, i8, i8 }, { %u8SCXY*, %u8SCXY*, i8, i8 }* %9, i64 0, i32 1
  store %u8SCXY* %0, %u8SCXY** %11, align 8
  %12 = getelementptr inbounds { %u8SCXY*, %u8SCXY*, i8, i8 }, { %u8SCXY*, %u8SCXY*, i8, i8 }* %9, i64 0, i32 2
  store i8 %1, i8* %12, align 8
  %13 = getelementptr inbounds { %u8SCXY*, %u8SCXY*, i8, i8 }, { %u8SCXY*, %u8SCXY*, i8, i8 }* %9, i64 0, i32 3
  store i8 %2, i8* %13, align 1
  %14 = bitcast { %u8SCXY*, %u8SCXY*, i8, i8 }* %9 to i8*
  call void @likely_fork(i8* bitcast (void ({ %u8SCXY*, %u8SCXY*, i8, i8 }*, i64, i64)* @binary_threshold_tmp_thunk0 to i8*), i8* %14, i64 %8)
  ret %u8SCXY* %7
}

attributes #0 = { nounwind readonly }
attributes #1 = { nounwind }

!0 = !{i32 1, i32 -1}
!1 = distinct !{!1}
