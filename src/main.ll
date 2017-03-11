target triple = "x86_64-apple-macosx10.10.0"

define i64 @linear_search(i32* %data, i64 %size, i32 %value) {
    ; allocate and initialize and index and start the loop
    %i = alloca i64   
    store i64 0, i64* %i
    br label %loop_start

    loop_start:
        ; get the value of data[i]
        %i_value = load i64* %i
        %data_at_i_ptr = getelementptr inbounds i32* %data, i64 %i_value
        %data_at_i = load i32* %data_at_i_ptr

        ; if i == value, goto return_current, else, goto loop_increment
        %found_value = icmp eq i32 %value, %data_at_i
        br i1 %found_value, label %return_current, label %loop_increment

    loop_increment:
        ; increment i
        %i_plus_1 = add i64 %i_value, 1
        store i64 %i_plus_1, i64* %i

        ; if !(i < list_size), goto loop_start, else, goto return_not_found
        %not_end_of_list = icmp slt i64 %i_plus_1, %size
        br i1 %not_end_of_list, label %loop_start, label %return_not_found

    return_current:
        ret i64 %i_value

    return_not_found:
        ret i64 -1;
}

define i64 @binary_search(i32* %data, i64 %size, i32 %value) {
    ; allocate and initialize start and end
    %start = alloca i64
    %end = alloca i64
    store i64 0, i64* %start
    store i64 %size, i64* %end

    br label %loop_start
    loop_start:
        ; calculate the middle index of the list slice defined by start and end
        %start_value = load i64* %start
        %end_value = load i64* %end
        %length = sub i64 %end_value, %start_value
        %half_length = lshr i64 %length, 1
        %middle = add i64 %start_value, %half_length

        ; get the value of data[middle]
        %data_at_middle_ptr = getelementptr inbounds i32* %data, i64 %middle
        %data_at_middle = load i32* %data_at_middle_ptr

        ; if data[middle] == value, goto return_middle, else, goto check_at_end
        %found_value = icmp eq i32 %value, %data_at_middle
        br i1 %found_value, label %return_middle, label %check_at_end

    check_at_end:
        ; if start is equal to middle we can finish searching
        ; if start == middle, goto return_not_found, else, goto check_value_lt_middle
        %at_end = icmp eq i64 %start_value, %middle
        br i1 %at_end, label %return_not_found, label %check_value_lt_middle

    check_value_lt_middle:
        ; if data[middle] < value, goto set_for_less_than, else, goto set_for_greater_than
        %value_lt_middle = icmp slt i32 %value, %data_at_middle
        br i1 %value_lt_middle, label %set_for_less_than, label %set_for_greater_than

    set_for_less_than:
        ; set end to middle and start the loop again
        store i64 %middle, i64* %end
        br label %loop_start

    set_for_greater_than:
        ; set start to middle and start the loop again
        store i64 %middle, i64* %start
        br label %loop_start

    return_middle:
        ret i64 %middle

    return_not_found:
        ret i64 -1
}


define i32 @main() {
    ; allocate a pointer for the data and read in the data using function in utils.h
    %data = alloca i32*
    %size = call i64 @read_data(i32** %data)
    %data_value = load i32** %data ; the value of the pointer stored at %data

    ; linear search for 22, 44, 47, 107, printing out the index the number was found at
    %found_22_at = call i64 @linear_search(i32* %data_value, i64 %size, i32 22)
    call void @println_size_t(i64 %found_22_at)
    %found_44_at = call i64 @linear_search(i32* %data_value, i64 %size, i32 44)
    call void @println_size_t(i64 %found_44_at)
    %found_47_at = call i64 @linear_search(i32* %data_value, i64 %size, i32 47)
    call void @println_size_t(i64 %found_47_at)
    %found_107_at = call i64 @linear_search(i32* %data_value, i64 %size, i32 107)
    call void @println_size_t(i64 %found_107_at)

    ; print new line
    call void @println()

    ; binary search for 92, 93, printing out the index the number was found at
    %found_92_at = call i64 @binary_search(i32* %data_value, i64 %size, i32 92)
    call void @println_size_t(i64 %found_92_at)
    %found_93_at = call i64 @binary_search(i32* %data_value, i64 %size, i32 93)
    call void @println_size_t(i64 %found_93_at)

    ret i32 0
}

declare i64 @read_data(i32**) ; read data in from file
declare void @println_int(i32) ; print int with new line
declare void @println_size_t(i64) ; print size_t as signed value, with new line
declare void @println() ; print new line
