#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// LinkedList je struktura obsahující prvek a zbytek listu
// nebo NULL
typedef struct LinkedList {
    const void* first;
    struct LinkedList* rest;
} LinkedList;

// Vytvoří node linked listu, očekává se že každý takto vytvořený
// node bude po použití uvolněn
LinkedList* cons(void* item, LinkedList* rest) {
    LinkedList* node = (LinkedList*) malloc(sizeof(LinkedList));
    node->first = item;
    node->rest = rest;
    return node;
}

void free_all(LinkedList* lst) {
    if (lst == NULL) {
        return;
    }
    LinkedList* rest = lst->rest;
    free(lst);
    return free_all(rest);
}

// Work reprezentuje výkaz práce za měsíc
typedef struct Work {
    const char* name;
    const char* surname;
    double rate;
    double hours;
} Work;

// Vytvoří dynamicky alokovanou hodnotu typu Work
Work* make_work(const char* name, const char* surname, const double rate, const double hours) {
    Work* work = (Work*) malloc(sizeof(Work));
    work->name = name;
    work->surname = surname;
    work->rate = rate;
    work->hours = hours;
    return work;
}

void free_work(Work* work) {
    free((char*) work->name);
    free((char*) work->surname);
    free(work);
}

// Payslip reprezentuje měsíční výplatní pásku
typedef struct Payslip {
    const char* name;
    const char* surname;
    double pay;
} Payslip;

// Vytvoří dynamicky alokovanou hodnotu typu Payslip
Payslip* make_payslip(const char* name, const char* surname, const double pay) {
    Payslip* payslip = (Payslip*) malloc(sizeof(Payslip));
    payslip->name = name;
    payslip->surname = surname;
    payslip->pay = pay;
    return payslip;
}

// Vytvoří dynamicky alokovanou hodnotu typu Payslip z hodnoty typu Work
Payslip* work_to_payslip(const Work* work) {
    return make_payslip(work->name, work->surname, work->hours * work->rate);
}

// Vytvoří list hodnot Payslip z listhu hodnot typu Work
LinkedList* to_payslips(LinkedList* works) {
    if (works == NULL) {
        return NULL;
    }
    return cons(work_to_payslip((const Work*) works->first), to_payslips(works->rest));
}

// Zparsuje string ve tvaru "Name Surname Rate Hours"
// do nového dynamicky alokovaného typu work
Work* parse_work(char* str) {
    // Pole 4 ukazatelů na jednotlivé části stringu
    char* parts[4];
    size_t i = 0;
    char* token = strtok(str, " ");
    while(token != NULL) {
        parts[i++] = token;
        token = strtok(NULL, " ");
    }
    double rate = strtod(parts[2], NULL);
    double hour = strtod(parts[3], NULL);
    return make_work(parts[0], parts[1], rate, hour);
}

// Vytvoří list hodnot work ze souboru
LinkedList* parse_all_work_bad(FILE* file) {
    char buffer[256];
    LinkedList* ll = NULL;
    while (fgets(buffer, sizeof(buffer), file) != 0) {
        size_t len = strlen(buffer);
        if (len > 0 && buffer[len-1] == '\n') {
            buffer[len-1] = '\0';
        }
        ll = cons(parse_work(buffer), ll);
    }
    fclose(file);
    return ll;
}

// Vytvoří list hodnot work ze souboru
LinkedList* parse_all_work(FILE* file, LinkedList** strings) {
    char buffer[256];
    LinkedList* ll = NULL;
    LinkedList* strs = *strings;
    while (fgets(buffer, sizeof(buffer), file) != 0) {
        size_t len = strlen(buffer);
        if (len > 0 && buffer[len-1] == '\n') {
            buffer[len-1] = '\0';
        }
        char* new_str = (char*) malloc(sizeof(char) * (len + 1));
        *strings = strs;
        strcpy(new_str, buffer);
        strs = cons(new_str, strs);
        ll = cons(parse_work(new_str), ll);
    }
    fclose(file);
    return ll;
}

// Zapíše výplatnice do souboru
void write_payslips(FILE* file, LinkedList* payslips) {
    if (payslips == NULL) {
        fclose(file);
        return;
    }
    Payslip* first = (Payslip*) payslips->first;
    fprintf(file, "%s %s - %f€\n", first->name, first->surname, first->pay);
    write_payslips(file, payslips->rest);
}

int main() {
    FILE* fin = fopen("input.txt", "r");
    FILE* fout = fopen("output.txt", "w");
    LinkedList* allocated_strings = NULL;
    LinkedList* works = parse_all_work(fin, &allocated_strings);
    LinkedList* payslips = to_payslips(works);
    write_payslips(fout, payslips);
    free_all(works);
    free_all(payslips);
    free_all(allocated_strings);
    return 0;
}
