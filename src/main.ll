target triple = "x86_64-apple-macosx10.10.0"

define i64 @linear_search(i32** %data, i64 %size, i32 %value) {
    %data_value = load i32** %data
    %i = alloca i64   
    store i64 0, i64* %i
    br label %loop_start

    loop_start:
        %i_value = load i64* %i
        %data_at_i_ptr = getelementptr inbounds i32* %data_value, i64 %i_value
        %data_at_i = load i32* %data_at_i_ptr
        %found_value = icmp eq i32 %value, %data_at_i
        br i1 %found_value, label %return_current, label %loop_increment

    loop_increment:
        %i_plus_1 = add i64 %i_value, 1
        store i64 %i_plus_1, i64* %i
        %not_end_of_list = icmp slt i64 %i_plus_1, %size
        br i1 %not_end_of_list, label %loop_start, label %return_not_found

    return_current:
        ret i64 %i_value

    return_not_found:
        ret i64 -1;
}

define i64 @binary_search(i32** %data, i64 %size, i32 %value) {
    %data_value = load i32** %data
    %start = alloca i64
    %end = alloca i64
    store i64 0, i64* %start
    store i64 %size, i64* %end

    br label %loop_start
    loop_start:
        %start_value = load i64* %start
        %end_value = load i64* %end
        %length = sub i64 %end_value, %start_value
        %half_length = lshr i64 %length, 1
        %middle = add i64 %start_value, %half_length

        %data_at_middle_ptr = getelementptr inbounds i32* %data_value, i64 %middle
        %data_at_middle = load i32* %data_at_middle_ptr
        %found_value = icmp eq i32 %value, %data_at_middle
        br i1 %found_value, label %return_middle, label %check_at_end

    check_at_end:
        %at_end = icmp eq i64 %start_value, %middle
        br i1 %at_end, label %return_not_found, label %check_value_lt_middle

    check_value_lt_middle:
        %value_lt_middle = icmp slt i32 %value, %data_at_middle
        br i1 %value_lt_middle, label %set_for_less_than, label %set_for_greater_than

    set_for_less_than:
        store i64 %middle, i64* %end
        br label %loop_start

    set_for_greater_than:
        store i64 %middle, i64* %start
        br label %loop_start

    return_middle:
        ret i64 %middle

    return_not_found:
        ret i64 -1
}


define i32 @main() {
    %data = alloca i32*
    %size = call i64 @read_data(i32** %data)

    %found_22_at = call i64 @linear_search(i32** %data, i64 %size, i32 22)
    call void @println_size_t(i64 %found_22_at)
    %found_44_at = call i64 @linear_search(i32** %data, i64 %size, i32 44)
    call void @println_size_t(i64 %found_44_at)
    %found_47_at = call i64 @linear_search(i32** %data, i64 %size, i32 47)
    call void @println_size_t(i64 %found_47_at)
    %found_107_at = call i64 @linear_search(i32** %data, i64 %size, i32 107)
    call void @println_size_t(i64 %found_107_at)

    call void @println()

    %found_92_at = call i64 @binary_search(i32** %data, i64 %size, i32 92)
    call void @println_size_t(i64 %found_92_at)
    %found_93_at = call i64 @binary_search(i32** %data, i64 %size, i32 93)
    call void @println_size_t(i64 %found_93_at)

    ret i32 0
}

declare i64 @read_data(i32**)
declare void @println_int(i32)
declare void @println_size_t(i64)
declare void @println()
