target triple = "x86_64-apple-macosx10.10.0"

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: nounwind ssp uwtable
define i32 @main() #0 {
  %data = alloca i32*, align 8
  %size = call i64 @read_data(i32** %data)

  %i = alloca i64, align 8
  store i64 0, i64* %i, align 8
  br label %loop_start

loop_start:
  %i_value = load i64* %i, align 8
  %i_lt_size = icmp ult i64 %i_value, %size
  br i1 %i_lt_size, label %loop_body, label %loop_end

loop_body:
  %data_value = load i32** %data, align 8
  %data_at_i_ptr = getelementptr inbounds i32* %data_value, i64 %i_value
  %data_at_i = load i32* %data_at_i_ptr, align 4
  %print_data_at_i = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str, i32 0, i32 0), i32 %data_at_i)
  %i_plus_1 = add i64 %i_value, 1
  store i64 %i_plus_1, i64* %i, align 8
  br label %loop_start

loop_end:
  ret i32 0
}

declare i64 @read_data(i32**) #1
declare i32 @printf(i8*, ...) #1
