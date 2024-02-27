open System

/// Reprezentuje výkaz práce za měsíc
type Work = {
    name: string
    surname: string
    rate: Decimal
    hours: Decimal
}

/// Reprezentuje měsíční výplatnici člověka
type Payslip = {
    name: string
    surname: string
    pay: Decimal
}

/// Převede výkaz práce na výplatnici
let workToPayslip (work: Work) = {
        name = work.name;
        surname = work.surname;
        pay = work.rate * work.hours;
    }

/// Převede list výkazů na list výplatnic
let rec toPayslips (works: Work list) =
    match works with
    | [] -> []
    | first::rest -> workToPayslip first :: toPayslips rest

/// Naparsuje string na hodnotu Work
let parseWork (s: string) =
    s.Trim() |> fun x -> x.Split " " |> fun x -> {
         name = x[0];
         surname = x[1]
         rate = Decimal.Parse(x[2])
         hours = Decimal.Parse(x[3])
    }

/// Naparsuje všechny stringy z listu na list hodnot Work
let rec parseAllWork (s: string list) =
    match s with
    | [] -> []
    | first::rest -> parseWork first :: parseAllWork rest

/// Vytvoří textovou reprezentaci hodnoty typu Payslip
let payslipToString (p: Payslip) =
    $"{p.name} {p.surname} - {p.pay}€"

/// Vytvoří list textových reprezentací výplatnic
let rec stringifyPayslips (p: Payslip list) =
    match p with
    | [] -> []
    | first::rest -> payslipToString first :: stringifyPayslips rest

/// Přečte soubor do listu stringů
let readLines filePath = System.IO.File.ReadAllLines(filePath) |> Array.toList

/// Zapíše list stringů do souboru
let writeLines filePath lines = System.IO.File.WriteAllLines(
    filePath,
    List.toArray lines
    )


[<EntryPoint>]
let main args =
    readLines "input.txt" |> parseAllWork |>
    toPayslips |> stringifyPayslips |>
    writeLines "output.txt"
    
    0