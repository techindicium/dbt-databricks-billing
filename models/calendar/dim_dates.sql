/* gerando datas usando a macro do pacote dbt-utils */
with
    dates_raw as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('1970-01-01' as date)",
        end_date="dateadd(year, 100, to_date(current_date()))"
        )
    }}
)

/* extraindo algumas informações da data e renomeando algumas colunas para o português */
    , days_info as (
        select
            cast(date_day as date) as date_day
            , dayofweek(date_day) as day_of_week
            , month(date_day) as month
            , quarter(date_day) as quarter
            , dayofyear(date_day) as day_of_year
            , year(date_day) as year
        from dates_raw
    )

/* renomeando os significados das colunas, traduzindo-os para o português */
    , days_named as (
        select
            *
            , case
                when day_of_week = 1 then 'Domingo'
                when day_of_week = 2 then 'Segunda-feira'
                when day_of_week = 3 then 'Terça-feira'
                when day_of_week = 4 then 'Quarta-feira'
                when day_of_week = 5 then 'Quinta-feira'
                when day_of_week = 6 then 'Sexta-feira'
                when day_of_week = 7 then 'Sábado'
            end as nome_do_dia
            , case
                when month = 1 then 'Janeiro'
                when month = 2 then 'Fevereiro'
                when month = 3 then 'Março'
                when month = 4 then 'Abril'
                when month = 5 then 'Maio'
                when month = 6 then 'Junho'
                when month = 7 then 'Julho'
                when month = 8 then 'Agosto'
                when month = 9 then 'Setembro'
                when month = 10 then 'Outubro'
                when month = 11 then 'Novembro'
                else 'Dezembro'
            end as nome_do_mes
            , case
                when month = 1 then 'Jan'
                when month = 2 then 'Fev'
                when month = 3 then 'Mar'
                when month = 4 then 'Abr'
                when month = 5 then 'Mai'
                when month = 6 then 'Jun'
                when month = 7 then 'Jul'
                when month = 8 then 'Ago'
                when month = 9 then 'Set'
                when month = 10 then 'Out'
                when month = 11 then 'Nov'
                else 'Dez'
            end as abrev_do_mes
            , case
                when quarter = 1 then '1º Trimestre'
                when quarter = 2 then '2º Trimestre'
                when quarter = 3 then '3º Trimestre'
                else '4º Trimestre'
            end as nome_trimestre
            , case
                when quarter in(1,2) then 1
                else 2
            end as semestre
            , case
                when quarter in(1,2) then '1º Semestre'
                else '2º Semestre'
            end as nome_semestre
            , case
                when day_of_week = 2 then 'Monday'
                when day_of_week = 3 then 'Tuesday'
                when day_of_week = 4 then 'Wednesday'
                when day_of_week = 5 then 'Thursday'
                when day_of_week = 6 then 'Friday'
                when day_of_week = 7 then 'Saturday'
                when day_of_week = 1 then 'Sunday'
            end as name_of_the_day
            , case
                when month = 1 then 'January'
                when month = 2 then 'February'
                when month = 3 then 'March'
                when month = 4 then 'April'
                when month = 5 then 'May'
                when month = 6 then 'June'
                when month = 7 then 'July'
                when month = 8 then 'August'
                when month = 9 then 'September'
                when month = 10 then 'October'
                when month = 11 then 'November'
                else 'December'
            end as name_of_the_month
            , case
                when month = 1 then 'Jan'
                when month = 2 then 'Feb'
                when month = 3 then 'Mar'
                when month = 4 then 'Apr'
                when month = 5 then 'May'
                when month = 6 then 'June'
                when month = 7 then 'July'
                when month = 8 then 'Aug'
                when month = 9 then 'Sept'
                when month = 10 then 'Oct'
                when month = 11 then 'Nov'
                else 'Dec'
            end as month_short_name
            , case
                when quarter = 1 then '1º Quarter'
                when quarter = 2 then '2º Quarter'
                when quarter = 3 then '3º Quarter'
                else '4º Quarter'
            end as quarter_name
            , case
                when quarter in(1,2) then 1
                else 2
            end as semester
            , case
                when quarter in(1,2) then '1º Semester'
                else '2º Semester'
            end as semester_name
        from days_info
    )

/* reorganizando as colunas */
    , final_cte as (
        select
            date_day
            , day_of_week
            , nome_do_dia
            , name_of_the_day
            , month
            , nome_do_mes
            , name_of_the_month
            , abrev_do_mes
            , month_short_name
            , quarter
            , nome_trimestre
            , quarter_name
            , semestre
            , semester
            , nome_semestre
            , semester_name
            , day_of_year
            , year
        from days_named
    )

select *
from final_cte