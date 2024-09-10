### Descrição do Merge Request

Descrição do problema resolvido pelo MR de forma mais resumida.

Adicione mídias como fotos ou vídeos para o entendimento em caso de adição de funcionalidade.

#### Problema inicial

* Descrição do problema inicial levantado na issue relacionada ao MR.

#### Solução

Descrição um pouco mais detalhada da solução, com funcionalidades adicionadas, por exemplo.

* funcionalidade 1.

##### Arquivos adicionados, modificados ou removidos:

Adicionados:

<details>
<summary>

`(COMMAND) exemplo.rb`:

</summary>

* Adicionada command responsável pela funcionalidade x.

</details>

<details>
<summary>

`(/path) exemplo_controller.rb`: 

</summary>

* controller responsável por x.

</details>

<details>
<summary>

`exemplo_serializer.rb`:

</summary>

Arquivo já existia no decidim original, porém foi sobrescrito adicionando uma verificação de existência de um objeto no método `metodo_exemplo`.

</details>

Modificados:

<details>
<summary>

`(/path) arquivo.rb:` 

</summary>

* metodo_exemplo?:
  * adicionado método para verificar se o usuário tem autorização para realizar a ação y.

</details>

<details>
<summary>

`(/path) show.html.erb`:

</summary>

* Adicionado dropdown z.

</details>

<details>
<summary>

`routes.rb`:

</summary>

* Adicionada a rota que deve ser chamada em x.

</details>

#### Problemas encontrados durante o desenvolvimento e soluções:

- Problema 1:
  * Solução:
- Problema 2:
  * Solução:
- Problema 3:
  * Solução:

#### Núcleo da implementação

1. **Command `exemplo`**
   * Principal responsável pela funcionalidade x, que chama o `exemplo_serializer` para adquirir z e então realiza w.
2. **Controller  `(/path) exemplo_controller`**
   - Definição do método y que inicia todo o fluxo de x.
3. **Permissions `(/path) permissions`** 
   - Responsável pela definição de quem pode ou não realizar x.

### Issue referenciada

Closes #numero_da_issue