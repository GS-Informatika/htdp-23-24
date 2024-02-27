import unittest
from vyplatnice.vyplatnice import *


class MyTestCase(unittest.TestCase):

    def setUp(self):
        super().__init__()
        self.work1 = Work("A", "B", Decimal(10), Decimal(1))
        self.work2 = Work("C", "D", Decimal(1), Decimal(5))
        self.work3 = Work("E", "F", Decimal(30), Decimal(2))

        self.payslip1 = Payslip("A", "B", 10)
        self.payslip2 = Payslip("C", "D", 5)
        self.payslip3 = Payslip("E", "F", 60)

    def test_work_to_payslip(self):
        self.assertEqual(work_to_payslip(self.work1), self.payslip1)
        self.assertEqual(work_to_payslip(self.work2), self.payslip2)
        self.assertEqual(work_to_payslip(self.work3), self.payslip3)

    def test_to_payslips(self):
        self.assertEqual(to_payslips([]), [])
        self.assertEqual(
            to_payslips([self.work1, self.work2, self.work3]),
            [self.payslip1, self.payslip2, self.payslip3]
        )

    def test_parse_work(self):
        work_str1 = "A B 10 1"
        work_str2 = "C D 1 5"
        work_str3 = "E F"

        self.assertEqual(parse_work(work_str1), self.work1)
        self.assertEqual(parse_work(work_str2), self.work2)
        self.assertRaises(ValueError, parse_work, work_str3)

    def test_parse_all_work(self):
        work_str1 = "A B 10 1"
        work_str2 = "C D 1 5"
        self.assertEqual(parse_all_work([]), [])
        self.assertEqual(
            parse_all_work([work_str1, work_str2]),
            [self.work1, self.work2]
        )

    def test_stringify_payslips(self):
        self.assertEqual(stringify_payslips([]), [])
        self.assertEqual(
            stringify_payslips([self.payslip1, self.payslip2]),
            ["A B - 10.00€", "C D - 5.00€"]
        )


if __name__ == '__main__':
    unittest.main()
