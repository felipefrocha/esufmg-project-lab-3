# Laboratório de Projetos 3

## Configurações iniciais (caminhos de arquivo no windows)
O arquivo de configuração necessário para alterar e disponibilizar um serviço remoto no CoppeliaSim encontram se 
* [remoteApiConnections](C:\Program Files\CoppeliaRobotics\CoppeliaSimEdu\remoteApiConnections.txt)
Os arquivos de bibliotéca ncessários para comunicar um programa em python com a RemoteAPI do CoppeliaSim são:
* [sim.py](C:\Program Files\CoppeliaRobotics\CoppeliaSimEdu\programming\remoteApiBindings\python\python\sim.py) 
* [simConst.py](C:\Program Files\CoppeliaRobotics\CoppeliaSimEdu\programming\remoteApiBindings\python\python\simConst.py)
* [remoteApi.dll|.so](C:\Program Files\CoppeliaRobotics\CoppeliaSimEdu\programming\remoteApiBindings\lib\windows|ubuntuxx_xx) 

## Proposta do problema
A fim de que uma grua em representação simulada seja teleoperada busca se a seguinte operação:
Transporte de uma moeda de 50centavos de Real, de uma plataforma a 30 centrimetro da torre da grua 
e com 8 cm de altura, para uma distância de 8 

## Progrma interface interna
A API Interna foi utilizada inicialmente como uma ferramenta de validação da mecanica e da fase inicial da simulação.
O programa escrito em lua e utilizando um interpretador de XML em tempo real para criar interfaces GUI, pode ser encontrado em 
[controCraneWindow](/controlCraneWindow.lua)


## GUI Tkinter em Python
Apos a validadção dos comandos emitidos pela interface escrita em lua, foi encotnrado os comandos equivalentes para serem 
utilizados pela interface Python.

### Componentes de sistema
Para que seja possivel comunicar com a API Remota e manipular os objetos disponiveis em tela fez necessário criar uma script
thread, que levanta um serviço de escuta socket em uma porta especificada. Dessa forma é possível manipular os objetos de tela.
O programa de serviço socket esta no arquivo [tese](/teste.lua)

