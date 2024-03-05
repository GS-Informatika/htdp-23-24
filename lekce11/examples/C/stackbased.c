#include <string.h>
#include <stdio.h>
#include <assert.h>
#include <stdlib.h>

typedef struct Work {
    const char* name;
    const char* surname;
    double rate;
    double hours;
} Work;

typedef struct Payslip {
    const char* name;
    const char* surname;
    double pay;
} Payslip;

void work_to_payslip(const Work* work, Payslip* out) {
    out->name = work->name;
    out->surname = work->surname;
    out->pay = work->hours * work->rate;
}

void line_to_work(char* line, Work* out) {
    char* tokens[4];
    size_t idx = 0;
    char* token = strtok(line, " ");
    while(token != NULL) {
        tokens[idx++] = token;
        token = strtok(NULL, " ");
    }
    assert(idx == 4);
    double rate = strtod(tokens[2], NULL);
    double hours = strtod(tokens[3], NULL);
    out->name = tokens[0];
    out->surname = tokens[1];
    out->rate = rate;
    out->hours = hours;
}

void process_line(char* line, FILE* out) {
    Work w;
    Payslip p;
    line_to_work(line, &w);
    work_to_payslip(&w, &p);
    fprintf(out, "%s %s - %0.2f€\n", p.name, p.surname, p.pay);
}

typedef struct Args {
    const char* input;
    const char* output;
} Args;

void parse_args(const int argc, const char* argv[], Args* args) {
    args->input = "input.txt";
    args->output = "output.txt";

    for (size_t idx = 1; idx < argc; idx++) {
        if (strcmp(argv[idx], "--input") == 0) {
            assert(idx < argc);
            args->input = argv[++idx];
        }

        if (strcmp(argv[idx], "--output") == 0) {
            assert(idx < argc);
            args->output = argv[++idx];
        }
    }
}

int main(const int argc, const char* argv[]) {
    Args a;
    parse_args(argc, argv, &a);
    FILE* file_in = fopen(a.input, "r");
    FILE* file_out = fopen(a.output, "w");
    if (file_in == NULL || file_out == NULL) {
        exit(EXIT_FAILURE);
    }

    char buffer[256];
    while (fgets(buffer, 256, file_in) != NULL) {
        process_line(buffer, file_out);
    }

    return EXIT_SUCCESS;
}