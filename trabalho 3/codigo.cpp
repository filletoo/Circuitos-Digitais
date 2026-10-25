#include <bits/stdc++.h>
#include <windows.h>
using namespace std;

#define LINHAS 4
#define COLUNAS 4

char teclas[LINHAS][COLUNAS] = {
  {'1', '2', '3', 'A'},
  {'4', '5', '6', 'B'},
  {'7', '8', '9', 'C'},
  {'*', '0', '#', 'D'}
};

int pinosLinhas[LINHAS] = {2, 3, 4, 5};
int pinosColunas[COLUNAS] = {6, 7, 8, 9};

int saidasA[] = {10,11,12,13};

void dec2bin(int dec, int bin[4]){
    int a0, a1, a2, a3, a4, a5, a6, a7, a8, a9;
    a0 = dec == 0; a7 = dec == 7; a1 = dec == 1; 
    a8 = dec == 8; a2 = dec == 2; a9 = dec == 9; 
    a3 = dec == 3; a4 = dec == 4; a5 = dec == 5; 
    a6 = dec == 6;

    bin[3] = a9 || a8;
   	bin[2] = a4 || a5 || a6 || a7;
   	bin[1] = a2 || a3 || a6 || a7;
   	bin[0] = a1 || a3 || a5 || a7 || a9;
}

void FFJK2E(int J, int K, int clk, int CLR, int PR, int &Q, int &nao_Q, int &Q_copia){
    if (clk == 0) return;
    
    if (CLR == 0 && PR == 1) {Q = 0; nao_Q = 1;}
    else if (CLR == 1 && PR == 0) {Q = 1; nao_Q = 0;}

    else if (CLR == 1 && PR == 1){
        if (J == 1 && K == 1) {Q = !(Q_copia); nao_Q = !(nao_Q);}
        else if (J == 0 && K == 1) {Q = 0; nao_Q = 1;}
        else if (J == 1 && K == 0) {Q = 1; nao_Q = 0;}
        else {Q = Q_copia;}
    }else{
        Q = 1; nao_Q = 1;
    }  
}

/*void FFJK2E_tatu(int T, int clk, int CLR, int PR, int &Q, int &nao_Q){
    FFJK2E(T, T , clk, CLR, PR, Q, nao_Q);
}*/

void FFJK2E_dado(int D, int clk, int CLR, int PR, int &Q, int &nao_Q, int &Q_copia){
    FFJK2E(D, !D,  clk, CLR, PR, Q, nao_Q, Q_copia);
}

int mux(int E_Q, int E_esquerda, int E_direita, int E_paralelo, char seletor){
    if (seletor == 'A') return E_Q;
    else if (seletor == 'B') return E_esquerda;
    else if (seletor == 'C') return E_direita;
    else if (seletor == 'D') return E_paralelo;
    else return 0;
}   

void conversor_universal(int clr, int clk, int E_paralelas[4], int E_esquerda, int E_direita, int Q[4], int nao_Q[4], char seletor){
    int Q_1[4] = {Q[0], Q[1], Q[2], Q[3]};
    
    int E_3 = mux(Q_1[3], Q_1[2], E_direita, E_paralelas[3], seletor);
    FFJK2E_dado(E_3, clk, !clr, 1, Q[3], nao_Q[3], Q_1[3]);

    int E_2 = mux(Q_1[2], Q_1[1], Q_1[3], E_paralelas[2], seletor);
    FFJK2E_dado(E_2, clk, !clr, 1, Q[2], nao_Q[2], Q_1[2]);

    int E_1 = mux(Q_1[1], Q_1[0], Q_1[2], E_paralelas[1], seletor);
    FFJK2E_dado(E_1, clk, !clr, 1, Q[1], nao_Q[1], Q_1[1]);

    int E_0 = mux(Q_1[0], E_esquerda, Q_1[1], E_paralelas[0], seletor);
    FFJK2E_dado(E_0, clk, !clr, 1, Q[0], nao_Q[0], Q_1[0]);
}

int clk = 1;
int Q , nao_Q;

void loop(){
    int num;
    char seletor;
    cout << "Num: ";
    cin >> num;
    //cout << "Seletor: ";
    //cin >> seletor;

    int entrada_A[4], entrada_B[4];
    int Q_A[4], Q_B[4];
    int nao_Q_A[4], nao_Q_B[4];

    dec2bin(num, entrada_A);
    dec2bin(num, entrada_B);
    
    cout << entrada_A[3] << entrada_A[2] << entrada_A[1] << entrada_A[0];
    cout << '\n';
    //clk = !(clk);

    // Do A
    conversor_universal(1, clk, entrada_A, Q_B[3], 0, Q_A, nao_Q_A, 'D');
    cout << "\nA: " << Q_A[3] << Q_A[2] << Q_A[1] << Q_A[0];
    // Do B
    conversor_universal(1, clk, entrada_B, 0, Q_A[0], Q_B, nao_Q_B, 'C');
    cout << " B: " << Q_B[3] << Q_B[2] << Q_B[1] << Q_B[0];

    //carregar A em paralelo
    conversor_universal(0, clk, entrada_A, Q_B[3], 0, Q_A, nao_Q_A, 'D');

    //carregar B em paraello
    //conversor_universal(0, clk, entrada_B, 0, Q_A[0], Q_B, nao_Q_B, 'D');
    //cout << "\nA: " << Q_A[3] << Q_A[2] << Q_A[1] << Q_A[0];

    for (int i = 0; i < 4; i++){
        int QA = Q_A[0];
        int QB = Q_B[3];
        conversor_universal(0, clk, entrada_A, QB, 0, Q_A, nao_Q_A, 'C');
        conversor_universal(0, clk, entrada_B, 0, QA, Q_B, nao_Q_B, 'C');
        
        cout << "\nA: " << Q_A[3] << Q_A[2] << Q_A[1] << Q_A[0];
        cout << " B: " << Q_B[3] << Q_B[2] << Q_B[1] << Q_B[0];
        Sleep(600);
    }
    cout << '\n';
}

int main(){
    //FFJK2E(1, 1, 1, 0, Q, nao_Q);
    //cout << Q << '\n' << nao_Q << '\n';
    while (true){
        loop();
    }
    return 0;
}