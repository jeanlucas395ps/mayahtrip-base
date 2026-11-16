# 00 — Tela de abertura

## Objetivo
Apresentar a marca enquanto o app carrega e decidir o destino do usuário: **Início** (sessão ativa) ou **Login** (sem sessão).

## Regras de negócio
1. A abertura sempre aparece ao iniciar o app.
2. Duração total: **2,7 s** até começar a saída; a saída dura **420 ms**.
3. Ao terminar:
   - com **sessão ativa** → vai para `05-inicio.md` (sem passar pelo login);
   - sem sessão → vai para `01-login.md`.
4. Não há interação na abertura (nenhum botão).
5. Sessão “ativa” é criada ao entrar com Google/e-mail, ao concluir o cadastro ou ao criar conta a partir do modo convidado; é apagada ao sair (`28-perfil.md`). Expiração da sessão por tempo: `A DEFINIR`.

## Layout
- Fundo sólido `#120F2A` ocupando a tela toda.
- **Traço decorativo**: curva lima `#C9FF27`, 2 px, pontas arredondadas, opacidade 55%, partindo da borda esquerda (x −20, y 250 numa tela de 390 × 844) até perto do centro (x 160, y 398).
- **Bloco central** (centralizado vertical e horizontalmente):
  1. Símbolo da marca, **76 px**, todo em lima `#C9FF27` (pontos + avião).
  2. Logotipo “mayahtrip” em branco, **178 px** de largura, 18 px abaixo do símbolo.
  3. Frase em Instrument Serif **22 px**, cor `#C9C6DA`, 14 px abaixo: “Sua viagem, *inteira*, num só lugar.” — a palavra “inteira” em itálico e lima.
- **Barra de progresso**: 120 × 3 px, centralizada, 64 px acima da base; trilho branco 12%; preenchimento lima, raio 2 px.

## Animações (em sequência)
| Elemento | Início | Duração | Efeito |
| --- | --- | --- | --- |
| Traço | 0,1 s | 1,0 s | Desenha da esquerda para a direita (`cubic-bezier(.65,0,.35,1)`); aos 1,6 s esmaece até 12% em 0,8 s |
| Pontos do símbolo | 0,55 s + 0,12 s por ponto | 0,5 s | Surgem de escala 0 → 1 com efeito mola |
| Avião do símbolo | 0,95 s | 0,8 s | Entra de (−18 px, +18 px) girado −8° até a posição final |
| Logotipo | 1,35 s | 0,7 s | Sobe de baixo (máscara) |
| Frase | 1,7 s | 0,7 s | Aparece subindo 8 px |
| Barra | 0,2 s | 2,3 s | Preenche 0 → 100% (`cubic-bezier(.4,0,.2,1)`) |
| Saída | 2,7 s | 0,55 s | Bloco central some e cresce para escala 1,08 |

A troca para a próxima tela é um esmaecimento cruzado de 320 ms.

## A DEFINIR
- Comportamento quando o carregamento real demora mais que 2,7 s (manter a abertura? mostrar erro?).
- Comportamento offline na abertura.
