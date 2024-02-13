import random
import argparse
from dataclasses import dataclass
from typing import Generator

@dataclass
class Work():
    firstname: str
    lastname: str
    rate: int
    hours: int

    def toString(self):
        return f"{self.firstname} {self.lastname} {self.rate} {self.hours}"

def main():
    parser = argparse.ArgumentParser(
                    prog="WorkGenerator",
                    description="Generates fake work data")
    
    parser.add_argument('-c', '--count', type=int, required=True)
    parser.add_argument('-o', '--output', type=str, required=True)
    args = parser.parse_args()
    
    with open("firstnames.dat", 'r') as fn:
        firstnames = fn.read().split(",")

    with open("surnames.dat", 'r') as ln:
        lastnames = ln.read().split(",")

    generated = generate(firstnames, lastnames, args.count)

    with open(args.output, 'w') as wrt:
        wrt.writelines(
            map(lambda x: x + "\n", map(Work.toString, generated))
        )


def generate(firstnames: list[str], lastnames: list[str], count: int) -> Generator[Work, None, None]:
    for _ in range(count):
        firstname = random.choice(firstnames)
        lastname = random.choice(lastnames)
        rate = round(random.randint(250, 700) / 10) * 10
        hours = random.randint(0, 40)
        yield Work(firstname, lastname, rate, hours)



if __name__ == main():
    main()
