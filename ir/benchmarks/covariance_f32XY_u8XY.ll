; ModuleID = 'likely'

%u0CXYT = type { i32, i32, i32, i32, i32, i32, [0 x i8] }
%u8XY = type { i32, i32, i32, i32, i32, i32, [0 x i8] }

; Function Attrs: nounwind readonly
declare noalias %u0CXYT* @likely_new(i32 zeroext, i32 zeroext, i32 zeroext, i32 zeroext, i32 zeroext, i8* noalias nocapture) #0

; Function Attrs: nounwind
declare void @llvm.assume(i1) #1

define %u8XY* @covariance(%u8XY*) {
entry:
  %1 = getelementptr inbounds %u8XY, %u8XY* %0, i64 0, i32 3
  %columns = load i32, i32* %1, align 4, !range !0
  %2 = call %u0CXYT* @likely_new(i32 8480, i32 1, i32 %columns, i32 1, i32 1, i8* null)
  %3 = getelementptr inbounds %u8XY, %u8XY* %0, i64 0, i32 4
  %rows = load i32, i32* %3, align 4, !range !0
  %4 = zext i32 %columns to i64
  %5 = getelementptr inbounds %u0CXYT, %u0CXYT* %2, i64 1
  %6 = bitcast %u0CXYT* %5 to float*
  %7 = ptrtoint %u0CXYT* %5 to i64
  %8 = and i64 %7, 31
  %9 = icmp eq i64 %8, 0
  call void @llvm.assume(i1 %9)
  %scevgep56 = bitcast %u0CXYT* %5 to i8*
  %10 = shl nuw nsw i64 %4, 2
  call void @llvm.memset.p0i8.i64(i8* %scevgep56, i8 0, i64 %10, i32 4, i1 false)
  %11 = zext i32 %rows to i64
  %12 = getelementptr inbounds %u8XY, %u8XY* %0, i64 0, i32 6, i64 0
  %13 = ptrtoint i8* %12 to i64
  %14 = and i64 %13, 31
  %15 = icmp eq i64 %14, 0
  call void @llvm.assume(i1 %15)
  br label %y_body

y_body:                                           ; preds = %x_exit8, %entry
  %y = phi i64 [ 0, %entry ], [ %y_increment, %x_exit8 ]
  %16 = mul nuw nsw i64 %y, %4
  br label %x_body7

x_body7:                                          ; preds = %y_body, %x_body7
  %x9 = phi i64 [ %x_increment10, %x_body7 ], [ 0, %y_body ]
  %17 = getelementptr float, float* %6, i64 %x9
  %18 = load float, float* %17, align 4
  %19 = add nuw nsw i64 %x9, %16
  %20 = getelementptr %u8XY, %u8XY* %0, i64 0, i32 6, i64 %19
  %21 = load i8, i8* %20, align 1
  %22 = uitofp i8 %21 to float
  %23 = fadd fast float %22, %18
  store float %23, float* %17, align 4
  %x_increment10 = add nuw nsw i64 %x9, 1
  %x_postcondition11 = icmp eq i64 %x_increment10, %4
  br i1 %x_postcondition11, label %x_exit8, label %x_body7

x_exit8:                                          ; preds = %x_body7
  %y_increment = add nuw nsw i64 %y, 1
  %y_postcondition = icmp eq i64 %y_increment, %11
  br i1 %y_postcondition, label %y_exit, label %y_body

y_exit:                                           ; preds = %x_exit8
  %24 = icmp eq i32 %rows, 1
  br i1 %24, label %Flow8, label %true_entry

true_entry:                                       ; preds = %y_exit
  %25 = uitofp i32 %rows to float
  %26 = fdiv fast float 1.000000e+00, %25
  br label %x_body15

Flow8:                                            ; preds = %x_body15, %y_exit
  %27 = call %u0CXYT* @likely_new(i32 24584, i32 1, i32 %columns, i32 %rows, i32 1, i8* null)
  %28 = getelementptr inbounds %u0CXYT, %u0CXYT* %27, i64 1
  %29 = ptrtoint %u0CXYT* %28 to i64
  %30 = and i64 %29, 31
  %31 = icmp eq i64 %30, 0
  call void @llvm.assume(i1 %31)
  %scevgep = getelementptr %u0CXYT, %u0CXYT* %27, i64 1, i32 0
  %scevgep1 = bitcast i32* %scevgep to i8*
  %scevgep2 = getelementptr %u8XY, %u8XY* %0, i64 1, i32 0
  %scevgep23 = bitcast i32* %scevgep2 to i8*
  br label %y_body30

x_body15:                                         ; preds = %true_entry, %x_body15
  %x17 = phi i64 [ %x_increment18, %x_body15 ], [ 0, %true_entry ]
  %32 = getelementptr float, float* %6, i64 %x17
  %33 = load float, float* %32, align 4, !llvm.mem.parallel_loop_access !1
  %34 = fmul fast float %33, %26
  store float %34, float* %32, align 4, !llvm.mem.parallel_loop_access !1
  %x_increment18 = add nuw nsw i64 %x17, 1
  %x_postcondition19 = icmp eq i64 %x_increment18, %4
  br i1 %x_postcondition19, label %Flow8, label %x_body15

y_body30:                                         ; preds = %y_body30, %Flow8
  %y32 = phi i64 [ 0, %Flow8 ], [ %y_increment38, %y_body30 ]
  %35 = mul i64 %y32, %4
  %uglygep = getelementptr i8, i8* %scevgep1, i64 %35
  %uglygep4 = getelementptr i8, i8* %scevgep23, i64 %35
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %uglygep, i8* %uglygep4, i64 %4, i32 1, i1 false)
  %y_increment38 = add nuw nsw i64 %y32, 1
  %y_postcondition39 = icmp eq i64 %y_increment38, %11
  br i1 %y_postcondition39, label %y_body45.preheader, label %y_body30

y_body45.preheader:                               ; preds = %y_body30
  %36 = bitcast %u0CXYT* %28 to i8*
  br label %y_body45

y_body45:                                         ; preds = %x_exit49, %y_body45.preheader
  %y47 = phi i64 [ 0, %y_body45.preheader ], [ %y_increment53, %x_exit49 ]
  %37 = mul nuw nsw i64 %y47, %4
  br label %x_body48

x_body48:                                         ; preds = %y_body45, %x_body48
  %x50 = phi i64 [ %x_increment51, %x_body48 ], [ 0, %y_body45 ]
  %38 = add nuw nsw i64 %x50, %37
  %39 = getelementptr i8, i8* %36, i64 %38
  %40 = load i8, i8* %39, align 1, !llvm.mem.parallel_loop_access !2
  %41 = getelementptr float, float* %6, i64 %x50
  %42 = load float, float* %41, align 4, !llvm.mem.parallel_loop_access !2
  %43 = uitofp i8 %40 to float
  %44 = fsub fast float %43, %42
  %45 = fptoui float %44 to i8
  store i8 %45, i8* %39, align 1, !llvm.mem.parallel_loop_access !2
  %x_increment51 = add nuw nsw i64 %x50, 1
  %x_postcondition52 = icmp eq i64 %x_increment51, %4
  br i1 %x_postcondition52, label %x_exit49, label %x_body48

x_exit49:                                         ; preds = %x_body48
  %y_increment53 = add nuw nsw i64 %y47, 1
  %y_postcondition54 = icmp eq i64 %y_increment53, %11
  br i1 %y_postcondition54, label %y_exit46, label %y_body45

y_exit46:                                         ; preds = %x_exit49
  %46 = call %u0CXYT* @likely_new(i32 24584, i32 1, i32 %columns, i32 %columns, i32 1, i8* null)
  %47 = getelementptr inbounds %u0CXYT, %u0CXYT* %46, i64 1
  %48 = bitcast %u0CXYT* %47 to i8*
  %49 = ptrtoint %u0CXYT* %47 to i64
  %50 = and i64 %49, 31
  %51 = icmp eq i64 %50, 0
  call void @llvm.assume(i1 %51)
  br label %y_body66

y_body66:                                         ; preds = %x_exit70, %y_exit46
  %y68 = phi i64 [ 0, %y_exit46 ], [ %y_increment78, %x_exit70 ]
  %52 = mul nuw nsw i64 %y68, %4
  br label %x_body69

x_body69:                                         ; preds = %y_body66, %Flow
  %x71 = phi i64 [ %x_increment76, %Flow ], [ 0, %y_body66 ]
  %53 = icmp ugt i64 %y68, %x71
  br i1 %53, label %Flow, label %true_entry74

x_exit70:                                         ; preds = %Flow
  %y_increment78 = add nuw nsw i64 %y68, 1
  %y_postcondition79 = icmp eq i64 %y_increment78, %4
  br i1 %y_postcondition79, label %y_exit67, label %y_body66

y_exit67:                                         ; preds = %x_exit70
  %dst = bitcast %u0CXYT* %46 to %u8XY*
  %54 = bitcast %u0CXYT* %2 to i8*
  call void @likely_release_mat(i8* %54)
  %55 = bitcast %u0CXYT* %27 to i8*
  call void @likely_release_mat(i8* %55)
  ret %u8XY* %dst

true_entry74:                                     ; preds = %x_body69, %true_entry74
  %56 = phi i32 [ %70, %true_entry74 ], [ 0, %x_body69 ]
  %57 = phi double [ %69, %true_entry74 ], [ 0.000000e+00, %x_body69 ]
  %58 = sext i32 %56 to i64
  %59 = mul nuw nsw i64 %58, %4
  %60 = add nuw nsw i64 %59, %x71
  %61 = getelementptr i8, i8* %36, i64 %60
  %62 = load i8, i8* %61, align 1, !llvm.mem.parallel_loop_access !3
  %63 = uitofp i8 %62 to double
  %64 = add nuw nsw i64 %59, %y68
  %65 = getelementptr i8, i8* %36, i64 %64
  %66 = load i8, i8* %65, align 1, !llvm.mem.parallel_loop_access !3
  %67 = uitofp i8 %66 to double
  %68 = fmul fast double %67, %63
  %69 = fadd fast double %68, %57
  %70 = add nuw nsw i32 %56, 1
  %71 = icmp eq i32 %70, %rows
  br i1 %71, label %exit75, label %true_entry74

Flow:                                             ; preds = %x_body69, %exit75
  %x_increment76 = add nuw nsw i64 %x71, 1
  %x_postcondition77 = icmp eq i64 %x_increment76, %4
  br i1 %x_postcondition77, label %x_exit70, label %x_body69

exit75:                                           ; preds = %true_entry74
  %72 = add nuw nsw i64 %x71, %52
  %73 = getelementptr i8, i8* %48, i64 %72
  %74 = fptoui double %69 to i8
  store i8 %74, i8* %73, align 1, !llvm.mem.parallel_loop_access !3
  %75 = mul nuw nsw i64 %x71, %4
  %76 = add nuw nsw i64 %75, %y68
  %77 = getelementptr i8, i8* %48, i64 %76
  store i8 %74, i8* %77, align 1, !llvm.mem.parallel_loop_access !3
  br label %Flow
}

; Function Attrs: nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i32, i1) #1

; Function Attrs: nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i32, i1) #1

declare void @likely_release_mat(i8* noalias nocapture)

attributes #0 = { nounwind readonly }
attributes #1 = { nounwind }

!0 = !{i32 1, i32 -1}
!1 = distinct !{!1}
!2 = distinct !{!2}
!3 = distinct !{!3}
