# batBench
Um Script simples, para fazer um Benchmark da Bateria do Notebook.

# Dependências
Esse Script tem apenas duas dependências: os pacotes `acpi` e o `upower`. Em algumas distros, o pacote `acpi` não vem instalado por padrão.

# Uso

O Uso dele é bem simples, com quatro maneiras de usar ele:
- `batbench.sh`: Esse é o modo mais simples. Ele simplesmente vai demonstrar a porcentagem atual da bateria, o tempo restante e o consumo atual
- `batbench.sh -l [VEZES]`: Esse é o modo de log do batBench. Ele irá fazer um log no número de vezes que o usuário pediu, na pasta `Logs` que estará na pasta do usuário. E o Script irá registrar os dados a cada cinco minutos.
- `batbench.sh -ut [VEZES] [INTERVALO]: Uma forma mais flexível do parâmetro `-l`. Esse parâmetro permite que você determine o intervalo entre os registros.
- `batbench.sh -b [LIMITE]: Esse é o modo de "benchmark". Nesse modo, os registros serão feitos a cada um minuto no arquivo de Log, até chegar na porcentagem desejada. Se não houver nenhuma entrada de porcentagem, o Script irá fazer os registros até a bateria chegar em `20%`.

# O Arquivo de Log
Os registros do Arquivo de Log, terão mais ou menos esse formato: 
```
[30-03-2025 - 01:01:34]
Bateria Atual: 90%
Tempo restante: 05:31:01
Taxa: 3,837W
```
E são quatro linhas:
- A primeira é a Data e Hora em que o Registro ocorreu
- A segunda é a Porcentagem atual da bateria
- A terceira é o tempo restante
- E a última é a taxa de Carga/Descarga da Bateria.

E no modo de Benchmark, tem um Bloco adicional, que é esse:
```
[Final do Benchmark] 
- Horário de Início: 30-03-2025 às 01:01:34 
- Bateria no Início: 90%
- Horário de Término: 30-03-2025 às 06:22:07 
- Bateria no Final: 6%

[O Teste durou 5h:20m:33s.]
```
