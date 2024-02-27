import argparse
import decimal
import sys
from dataclasses import dataclass
from decimal import Decimal
from typing import TextIO


@dataclass
class Work:
    """
    Reprezentuje výkaz práce za měsíc
    """
    name: str
    surname: str
    rate: decimal
    hours: decimal


@dataclass
class Payslip:
    """
    Reprezentuje měsíční výplatnici člověka
    """
    name: str
    surname: str
    pay: decimal

    # Převod na textovou reprezentaci
    def __str__(self):
        return f"{self.name} {self.surname} - {self.pay:.2f}€"


def work_to_payslip(work: Work) -> Payslip:
    """
    Převede výkaz práce na výplatnici
    :param work: Výkaz práce člověka
    :return: Výplatnice člověka
    """
    return Payslip(
        name=work.name,
        surname=work.surname,
        pay=work.rate * work.hours
    )


def to_payslips(works: list[Work]) -> list[Payslip]:
    """
    Převede list výkazů práce na list výplatnice
    :param works: List výkazů práce
    :return: List výplatnic
    """
    return [work_to_payslip(work) for work in works]


def parse_work(string: str) -> Work:
    """
    Převede textovou reprezentaci výkazu práce na výkaz práce
    Očekává formát "Name Surname Rate Hours"
    :param string: Textová reprezentace výkazu práce ve správném formátu
    :return: Výkaz práce
    """
    split = string.split()
    if len(split) != 4:
        raise ValueError("String has wrong format, expected Name Surname Rate Hours")
    return Work(
        name=split[0],
        surname=split[1],
        rate=Decimal(split[2]),
        hours=Decimal(split[3])
    )


def parse_all_work(strs: list[str]) -> list[Work]:
    """
    Převede list textových reprezentací výkazů práce na list
    výkazů práce
    U jednotlivých výkazy práce se očekává formát "Name Surname Rate Hours"
    :param strs: Textové reprezentace výkazů práce
    :return: List výkazů práce
    """
    return [parse_work(s) for s in strs]


def stringify_payslips(payslips: list[Payslip]) -> list[str]:
    """
    Vytvoří list stringových reprezentací výplatnic z listu výplatnic
    :param payslips: List výplatnic
    :return: List textových reprezentací výplatnic
    """
    return [str(p) for p in payslips]


def main(input_file: TextIO, output_file: TextIO):
    """
    Z výkazů práce ve file-in vytvoří záznamy výplatnic ve file-out
    :param input_file: Soubor s výkazy práce
    :param output_file: Soubor do kterého se zaznamenají výplatnice
    """
    output_file.write(
        "\n".join(
            stringify_payslips(
                to_payslips(
                    parse_all_work(
                        input_file.readlines()
                    )
                )
            )
        )
    )

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog="Výplatnice",
        description="Převede výkazy práce na záznamy výplatnic",
    )
    parser.add_argument("-i", "--input", help="input file", default=None)
    parser.add_argument("-o", "--output", help="output file", default=None)
    args = parser.parse_args()
    if (args.input is None) or (args.output is None):
        main(sys.stdin, sys.stdout)
    else:
        with open(args.input, "r") as file_in:
            with open(args.output, "w") as file_out:
                main(file_in, file_out)
