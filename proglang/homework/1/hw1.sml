fun is_older (date1: int*int*int, date2: int*int*int) =
    if #1 date1 < #1 date2 then
        true
    else if #1 date1 > #1 date2 then
        false
    else if #2 date1 < #2 date2 then
        true
    else if #2 date1 > #2 date2 then
        false
    else if #3 date1 < #3 date2 then
        true
    else
        false


fun number_in_month(dates: (int*int*int) list, target_month: int) =
    if null dates then
        0
    else
        if #2(hd dates) = target_month then
            1 + number_in_month(tl dates, target_month)
        else
            number_in_month(tl dates, target_month)


fun number_in_months(dates: (int*int*int) list, target_months: int list) =
    if null target_months then
        0
    else
        number_in_month(dates, (hd target_months)) + number_in_months(dates, tl target_months)


fun dates_in_month(dates: (int*int*int) list, target_month) =
    if null dates then
        []
    else
        if #2(hd dates) = target_month then
            (hd dates) :: dates_in_month(tl dates, target_month)
        else
            dates_in_month(tl dates, target_month)


fun dates_in_months(dates: (int*int*int) list, target_months: int list) =
    if null target_months then
        []
    else
        dates_in_month(dates, hd target_months) @ dates_in_months(dates, tl target_months)


fun get_nth(datas: 'a list, n: int) =
    if n = 1 then
        hd datas
    else
        get_nth(tl datas, n-1)


fun date_to_string(date: int*int*int) =
    let
        val month_string_list = ["January", "February", "March", "April", "May", "June",
                              "July", "August", "September", "October", "November", "Decembe"]
    in
        get_nth(month_string_list, #2 date) ^ " " ^ Int.toString(#3 date) ^ ", " ^ Int.toString(#1 date)
    end


fun number_before_reaching_sum(sum: int, num_list: int list) =
    if null num_list orelse hd num_list >= sum then
        0
    else
        1 + number_before_reaching_sum(sum - hd num_list, tl num_list)


fun what_month(day: int) =
    let
        val month_day = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    in
        number_before_reaching_sum(day, month_day) + 1
    end


fun month_range(day_start: int, day_end: int) =
    if day_start > day_end then
        []
    else
        if day_start = day_end then
            [what_month(day_start)]
        else
            what_month(day_start) :: month_range(day_start+1, day_end)


fun oldest(day_list: (int*int*int) list) =
    if null day_list then
       NONE
    else
        let
            val tl_oldest_option = oldest(tl day_list)
        in
            if isSome tl_oldest_option andalso is_older(valOf tl_oldest_option, hd day_list) then
                tl_oldest_option
            else
                SOME (hd day_list)
        end

fun unique(data_list: ''a list) =
    let
        fun is_in_list(data: ''a, d_list: ''a list) =
            if null d_list then
                false
            else
                if hd d_list = data then
                    true
                else
                    is_in_list(data, tl d_list)

        fun unique_helper(unique_data_list: ''a list, data_list: ''a list) =
            if null data_list then
                unique_data_list
            else
                if is_in_list(hd data_list, unique_data_list) then
                    unique_helper(unique_data_list, tl data_list)
                else
                    unique_helper(unique_data_list @ [hd data_list], tl data_list)
    in
        unique_helper([], data_list)
    end


fun number_in_months_challenge(dates: (int*int*int) list, target_months: int list) =
    number_in_months(dates, unique(target_months))


fun dates_in_months_challenge(dates: (int*int*int) list, target_months: int list) =
    dates_in_months(dates, unique(target_months))


fun reasonable_date(date: int*int*int) =
    let
        fun is_legal_year(year: int) =
            year > 0
        fun is_leap_year(year: int) =
            is_legal_year(year) andalso (year mod 400 = 0 orelse (year mod 4 = 0 andalso year mod 100 <> 0))
        fun year_month_n_day(year) =
            if is_leap_year(year) then
                [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
            else
                [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        fun is_legal_month(month: int) =
            month > 0 andalso month <= 12
    in
        if is_legal_year(#1 date) andalso is_legal_month(#2 date) then
            #3 date > 0 andalso #3 date <= get_nth(year_month_n_day(#1 date), #2 date)
        else
            false
    end
