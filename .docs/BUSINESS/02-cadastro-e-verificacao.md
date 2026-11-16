# 02 — Cadastro e verificação de e-mail

## Objetivo
Criar uma conta com nome, e-mail e senha, confirmando o e-mail por **código de 4 dígitos**.

## Acesso
“Criar conta grátis” (login início), “Criar conta” (login e-mail).

## Indicador de passos
Topo do painel: 2 barras de 4 px (raio 2 px) lado a lado + texto “1 de 2” / “2 de 2” (12 px/700, `#5E5A73`). Barra concluída `#2B207F`, pendente `#E5E3EC`, transição de cor 300 ms.

## Passo 1 — Dados
Título editorial 34 px “Crie sua conta”, subtítulo 13 px “Grátis. Leva menos de 1 minuto.”, botão voltar (38 px) → login início.

Campos (rótulo 12 px/700 `#5E5A73` acima; campo 50 px, raio 16 px):
1. **Nome** — placeholder “Como quer ser chamado”.
2. **E-mail** — placeholder “voce@email.com”.
3. **Senha** — placeholder “Mínimo 8 caracteres”, botão de olho.
4. **Medidor de força** (4 barras de 4 px + rótulo à direita, 62 px):

| Pontos | Rótulo | Cor |
| --- | --- | --- |
| vazio | — | `#E5E3EC` |
| 1 | Fraca | `#D2462A` |
| 2 | Razoável | `#E2A92A` |
| 3 | Boa | `#5FB8A2` |
| 4+ | Forte | `#3A9A2E` |

Um ponto para cada: ≥ 8 caracteres; letra maiúscula; número; símbolo; ≥ 12 caracteres (máximo exibido = 4). Atualiza a cada tecla, transição 250 ms.

5. Caixa **Aceito os Termos de uso e a Política de privacidade** (desmarcada por padrão).
6. Botão **Continuar** (primário 54 px).
7. “Já tem conta?” + **Entrar**.

### Validações (ordem, a primeira falha é exibida em 12 px/700 `#D2462A` acima do botão)
1. Nome vazio → “Digite seu nome.”
2. E-mail inválido → “Digite um e-mail válido.”
3. Senha < 8 caracteres → “A senha precisa ter pelo menos 8 caracteres.”
4. Termos não aceitos → “Aceite os termos para continuar.”

Ao errar, os valores digitados são mantidos. Se tudo certo: botão com indicador giratório, envio do código por e-mail e aviso “Código enviado para {e-mail}”.

## Passo 2 — Verificação
Título “Verifique seu e-mail”; subtítulo “Enviamos um código de 4 dígitos para **{e-mail}**.”; voltar → passo 1.

### Caixas do código
- 4 caixas de **62 × 70 px**, raio 18 px, borda 1,5 px `#E5E3EC`, número 30 px/800, espaço 10 px, centralizadas.
- Foco: borda `#2B207F` + halo 4 px `#EBE8FF`. Preenchida: borda roxa e sobe 2 px (mola).
- Aceita só dígitos; ao digitar, pula para a próxima; Backspace numa caixa vazia volta e apaga a anterior; colar 4 dígitos preenche tudo e valida.
- O teclado numérico abre automaticamente na 1ª caixa (450 ms após entrar).

### Regras
1. Validação automática ao completar os 4 dígitos.
2. Código correto → caixas ficam verdes (borda `#3A9A2E`, fundo `#EEFFC2`) e, após 450 ms, vai para **Conta criada**.
3. Código errado → caixas com borda `#D2462A`, tremor horizontal de ±8 px em 400 ms e mensagem: “Código incorreto. Você ainda tem N tentativas.” (singular quando N = 1).
4. **Limite de 5 tentativas.** Na 5ª falha: “Você errou 5 vezes. Por segurança, peça um novo código.”, caixas desativadas e botão **Reenviar código** vira botão primário (40 px).
5. **Reenviar**: liberado após **30 s** (texto “Reenviar código em 0:SS”, contagem a cada 1 s); depois mostra “Não recebeu?” + link **Reenviar código**. Reenviar zera as tentativas, desbloqueia as caixas, reinicia os 30 s e mostra o aviso “Novo código enviado para {e-mail}”.
6. Validade do código: **10 minutos** (texto exibido na recuperação de senha; no cadastro `A DEFINIR` se exibe o mesmo texto).
7. Começar a digitar apaga a mensagem de erro.

## Conta criada
- Ícone de check 34 px em bloco lima 72 × 72 px, raio 24 px, entrada com “pop” (mola, 500 ms).
- Título editorial 36 px “Conta criada!”; texto “E-mail confirmado. Bem-vindo ao MayahTrip, {nome}.”
- Botão **Começar a explorar** (ícone bússola) → cria sessão, abre o Início e mostra “Bem-vindo, {primeiro nome}!”.
- O nome do perfil passa a ser o nome digitado e o usuário (@) a parte do e-mail antes do “@”.

## A DEFINIR
- Unicidade e regras do @usuário gerado automaticamente.
- O que fazer se o e-mail já tiver conta.
- Envio do e-mail de boas-vindas.
