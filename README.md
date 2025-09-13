# Movie Searcher — README

Um app Flutter para buscar filmes na OMDb API, com tema claro/escuro, histórico recente e layout responsivo.

## Requisitos

* **Flutter SDK:** **≥ 3.35.3** (vem com **Dart ≥ 3.9.2**).

  > O projeto fixa `environment: sdk: ^3.9.2` e os logs mostram Flutter **3.35.3**/Dart **3.9.2**.
* **Android**

  * **JDK:** **≥ 17** (recomendado 17 ou 21). O AGP usado exige Java 17+.
  * **Android Gradle Plugin (AGP):** **8.9.1** (gerenciado pelo Flutter (compatível com Gradle 8.12 e Java 17+)).
  * **Gradle Wrapper:** **8.12** (já vem no repo).
  * **Android SDK Platform/Build-Tools/Platform-Tools:** instale os pacotes mais recentes no Android Studio (compatíveis com o `compileSdkVersion` do seu Flutter).
  * **Dispositivo/Emulador mínimo (minSdk):** **API 21 (Android 5.0)**.
* **iOS** (opcional, apenas para builds no macOS)

  * **Xcode:** **≥ 15** (recomendado).
  * **CocoaPods:** **≥ 1.13**.
  * **Deployment Target (MinimumOSVersion):** **iOS 13.0** (definido em `ios/Flutter/AppFrameworkInfo.plist`).
* **Sistema operacional para desenvolvimento:**

  * Windows 10/11, macOS 13+ (Apple Silicon ou Intel) ou Linux x64 recente.

## Configuração da API (OMDb)

O app lê a base e a chave da API via `--dart-define`. Crie um arquivo `env.dev.json` na raiz do projeto com:

```json
{
  "OMDB_BASE_URL": "https://www.omdbapi.com/",
  "OMDB_API_KEY": "SUA_CHAVE_AQUI"
}
```

## Rodando o app

1. Instale dependências:

    ```bash
    flutter pub get
    ```

    (Caso use android) Conecte um dispositivo Android (ou inicie um emulador) e confirme com:

      ```bash
      adb devices
      ```

2. Rode em **debug**:

    ```bash
    flutter run --dart-define-from-file=env.dev.json
    ```

Se tiver mais de um device, escolha com `-d <deviceId>` (ex.: `-d chrome`, `-d windows`, `-d <seu-aparelho>`).

### Outros alvos

* **Web** (experimental): `flutter run -d chrome`
* **iOS** (macOS): abra `ios/` no Xcode ou use `flutter run -d <simulator>`

## Build

### Android (APK)

```bash
flutter build apk --dart-define-from-file=env.dev.json
```

### iOS (Archive)

```bash
flutter build ipa --dart-define-from-file=env.dev.json
```

## Testes e Qualidade

* **Testes unitários**

```bash
flutter test
```

* **Análise estática**

```bash
flutter analyze
```

## Estrutura do Projeto (resumo)

``` bash
lib/
├── data/                 # Camada de dados (DTOs, serviços HTTP, repositórios)
├── domain/               # Modelos de domínio
├── ui/
│   ├── core/             # Tema, toggle de tema e utilidades de layout
│   └── movies/
│       ├── view_models/  # BLoCs/Cubits (estado da busca, detalhes, recentes, adaptabilidade)
│       ├── views/        # Páginas (Search, Detail, Recent)
│       └── widgets/      # Widgets reutilizáveis (Cartão, Grid, SearchBar, Slivers)
└── di.dart               # Montagem do app, injeção de dependências e rotas
```

### Gestão de estado (resumo)

* `SearchBloc`: cuida da **busca** (debounce, loading, sucesso/erro).
* `SearchAdaptabilityCubit`: cuida apenas da **responsividade** (layout da barra e nº de colunas), atualizado via `LayoutBuilder`.
* `ThemeCubit`: controla **ThemeMode** (claro/escuro/sistema) persistindo em `SharedPreferences`.

## Dicas / Troubleshooting em Android

* **AGP requer Java 17**
  Erro: `Android Gradle plugin requires Java 17 to run`
  → Ajuste `JAVA_HOME` para um JDK 17+ válido e reinicie o terminal/IDE.

  ```bash
  echo %JAVA_HOME%       # Windows
  echo $JAVA_HOME        # macOS/Linux
  java -version
  ```

* **JAVA\_HOME inválido**
  Erro: `JAVA_HOME is set to an invalid directory`
  → Aponte para a pasta raiz do JDK (ex.: `C:\Program Files\Microsoft\jdk-21.0.8.9-hotspot`).

* **Nenhum device listado**
  → Habilite "Modo desenvolvedor", "Depuração USB" no Android, aceite a chave no telefone e verifique com `adb devices`.

* **Falha ao buscar / sem resultados**
  → Verifique a sua chave **OMDB\_API\_KEY** e a URL. Tente no navegador:
  `https://www.omdbapi.com/?apikey=SUA_CHAVE&s=matrix&type=movie`
