; ModuleID = 'likely'

%u0CXYT = type { i32, i32, i32, i32, i32, i32, [0 x i8] }
%u16SXY = type { i32, i32, i32, i32, i32, i32, [0 x i16] }
%u16SCXY = type { i32, i32, i32, i32, i32, i32, [0 x i16] }

; Function Attrs: nounwind
declare void @llvm.assume(i1) #0

; Function Attrs: nounwind readonly
declare noalias %u0CXYT* @likely_new(i32 zeroext, i32 zeroext, i32 zeroext, i32 zeroext, i32 zeroext, i8* noalias nocapture) #1

; Function Attrs: nounwind
define %u16SXY* @convert_grayscale(%u16SCXY*) #0 {
entry:
  %1 = getelementptr inbounds %u16SCXY, %u16SCXY* %0, i64 0, i32 2
  %channels = load i32, i32* %1, align 4, !range !0
  %2 = icmp eq i32 %channels, 3
  tail call void @llvm.assume(i1 %2)
  %3 = getelementptr inbounds %u16SCXY, %u16SCXY* %0, i64 0, i32 3
  %columns = load i32, i32* %3, align 4, !range !0
  %4 = getelementptr inbounds %u16SCXY, %u16SCXY* %0, i64 0, i32 4
  %rows = load i32, i32* %4, align 4, !range !0
  %5 = tail call %u0CXYT* @likely_new(i32 25616, i32 1, i32 %columns, i32 %rows, i32 1, i8* null)
  %6 = zext i32 %rows to i64
  %dst_y_step = zext i32 %columns to i64
  %7 = getelementptr inbounds %u0CXYT, %u0CXYT* %5, i64 1
  %8 = bitcast %u0CXYT* %7 to i16*
  %9 = ptrtoint %u0CXYT* %7 to i64
  %10 = and i64 %9, 31
  %11 = icmp eq i64 %10, 0
  tail call void @llvm.assume(i1 %11)
  %src_c = zext i32 %channels to i64
  %12 = getelementptr inbounds %u16SCXY, %u16SCXY* %0, i64 1
  %13 = bitcast %u16SCXY* %12 to i16*
  %14 = ptrtoint %u16SCXY* %12 to i64
  %15 = and i64 %14, 31
  %16 = icmp eq i64 %15, 0
  tail call void @llvm.assume(i1 %16)
  %17 = mul nuw nsw i64 %6, %dst_y_step
  br label %y_body

y_body:                                           ; preds = %y_body, %entry
  %y = phi i64 [ 0, %entry ], [ %y_increment, %y_body ]
  %18 = mul nuw nsw i64 %y, %src_c
  %19 = getelementptr i16, i16* %13, i64 %18
  %20 = load i16, i16* %19, align 2, !llvm.mem.parallel_loop_access !1
  %21 = add nuw nsw i64 %18, 1
  %22 = getelementptr i16, i16* %13, i64 %21
  %23 = load i16, i16* %22, align 2, !llvm.mem.parallel_loop_access !1
  %24 = add nuw nsw i64 %18, 2
  %25 = getelementptr i16, i16* %13, i64 %24
  %26 = load i16, i16* %25, align 2, !llvm.mem.parallel_loop_access !1
  %27 = zext i16 %20 to i32
  %28 = mul nuw nsw i32 %27, 1868
  %29 = zext i16 %23 to i32
  %30 = mul nuw nsw i32 %29, 9617
  %31 = zext i16 %26 to i32
  %32 = mul nuw nsw i32 %31, 4899
  %33 = add nuw nsw i32 %28, 8192
  %34 = add nuw nsw i32 %33, %30
  %35 = add nuw i32 %34, %32
  %36 = lshr i32 %35, 14
  %37 = trunc i32 %36 to i16
  %38 = getelementptr i16, i16* %8, i64 %y
  store i16 %37, i16* %38, align 2, !llvm.mem.parallel_loop_access !1
  %y_increment = add nuw nsw i64 %y, 1
  %y_postcondition = icmp eq i64 %y_increment, %17
  br i1 %y_postcondition, label %y_exit, label %y_body, !llvm.loop !1

y_exit:                                           ; preds = %y_body
  %39 = bitcast %u0CXYT* %5 to %u16SXY*
  ret %u16SXY* %39
}

attributes #0 = { nounwind }
attributes #1 = { nounwind readonly }

!0 = !{i32 1, i32 -1}
!1 = distinct !{!1}