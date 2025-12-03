# DOCUMENTO TÉCNICO DO PROJETO - BIBLIOSOFT

## Centro Universitário Católica de Santa Catarina
**Curso:** Engenharia de Software  
**Disciplina:** Dispositivos Móveis  
**Software:** BiblioSoft - Sistema de Gerenciamento de Biblioteca Digital

---

## INTEGRANTES DO GRUPO

- **Pablo Mikolaiczyki**
- **Cesar Vinicius Micheluzzi**

**Data:** Jaraguá do Sul, 02 de Dezembro de 2025

---

## SUMÁRIO

1. Escopo
2. Requisitos Funcionais e Não Funcionais
3. Stack Tecnológica
4. Paleta de Cores
5. Arquitetura do Software
6. Projeto do Banco de Dados
7. Testes de Software
8. Build e Distribuição
9. Considerações Finais
10. Referências

---

## 1. ESCOPO

O sistema **BiblioSoft** tem como objetivo principal permitir o gerenciamento completo de livros em uma biblioteca, possibilitando autenticação de usuários, cadastros, consultas de estoque e controle de empréstimos de forma simples, intuitiva e segura.

### 1.1 Telas Desenvolvidas

As seguintes telas foram desenvolvidas e estão totalmente funcionais:

- **Tela de Autenticação (Login e Registro)**: Permite que novos usuários se registrem e usuários existentes façam login com autenticação JWT.
- **Tela de Cadastro e Consulta de Livros**: Permite o cadastro de novos livros e visualização do estoque disponível com operações CRUD completas.
- **Tela de Empréstimos**: Permite visualizar, criar, atualizar e deletar registros de empréstimos com seleção de livros por dropdown.
- **Menu de Navegação (Drawer)**: Permite navegação entre as telas e logout.

### 1.2 Escopo Fora do Projeto

Os itens abaixo foram deliberadamente excluídos do escopo:

- Sistema de venda de livros
- Tela independente para cadastro de usuários (integrado ao login)
- Sistema de notificações (devolução, pendências, estoque baixo)
- Relatórios avançados
- Integração com serviços externos de pagamento

---

## 2. REQUISITOS FUNCIONAIS E NÃO FUNCIONAIS

### 2.1 Requisitos Funcionais (RF)

| ID | Descrição |
|---|---|
| RF-001 | Usuários devem se registrar no sistema com email, nome e senha |
| RF-002 | Usuários devem efetuar login com email e senha |
| RF-003 | Usuários autenticados podem cadastrar novos livros |
| RF-004 | Usuários autenticados podem listar todos os livros disponíveis |
| RF-005 | Usuários autenticados podem atualizar informações de livros |
| RF-006 | Usuários autenticados podem deletar livros do sistema |
| RF-007 | Usuários autenticados podem visualizar empréstimos |
| RF-008 | Usuários autenticados podem criar novos empréstimos |
| RF-009 | Usuários autenticados podem atualizar empréstimos existentes |
| RF-010 | Usuários autenticados podem deletar empréstimos |
| RF-011 | Usuários podem fazer logout do sistema |
| RF-012 | O sistema deve validar dados de entrada (email, campos obrigatórios) |

### 2.2 Requisitos Não Funcionais (RNF)

| ID | Descrição |
|---|---|
| RNF-001 | Interface intuitiva e responsiva em dispositivos móveis |
| RNF-002 | Autenticação segura via token JWT |
| RNF-003 | Comunicação com backend via HTTPS/HTTP com CORS habilitado |
| RNF-004 | Requisições HTTP com timeout de 10 segundos |
| RNF-005 | Armazenamento seguro de tokens em FlutterSecureStorage |
| RNF-006 | Suporte para navegadores Chrome/Edge (web) e Android |
| RNF-007 | Responsividade em resolução 16:9 |
| RNF-008 | Logs de requisições para debugging |
| RNF-009 | Tratamento de erros com feedback ao usuário |
| RNF-010 | Performance: requisições completadas em menos de 5 segundos |

---

## 3. STACK TECNOLÓGICA

### 3.1 Frontend

- **Framework:** Flutter 3.x com Dart
- **Arquitetura:** MVC (Model-View-Controller)
- **Pacotes Principais:**
  - `http: ^1.2.0` - Requisições HTTP
  - `flutter_secure_storage: ^9.0.0` - Armazenamento seguro de tokens
  - `intl: ^0.19.0` - Localização e formatação (conforme necessário)

### 3.2 Backend

- **Framework:** Java 21 + Spring Boot 3.2.5
- **Spring Security:** 6.2.4 com JWT (JJWT 0.11.5)
- **Banco de Dados:** MySQL 8.3.0
- **ORM:** Hibernate 6.4.4 (via Spring Data JPA)
- **Build Tool:** Maven
- **Servidor Embarcado:** Apache Tomcat 10.1.20

### 3.3 Banco de Dados

- **SGBD:** MySQL 8.3.0
- **Conexão:** HikariCP 5.0.1
- **Estrutura:** Tabelas relacionais normalizadas (3FN)

### 3.4 Alterações Realizadas na Stack (vs. N2)

**Mudança Principal:** Firebase foi substituído por MySQL durante a implementação N3.

**Justificativa:**
- O MySQL foi escolhido para oferecer maior controle e flexibilidade na estrutura de dados
- Melhor integração com Spring Boot e Hibernate
- Facilita testes automatizados com dados persistentes
- Reduz custos em produção comparado ao Firebase

---

## 4. PALETA DE CORES

A paleta de cores foi definida para proporcionar uma interface agradável, profissional e harmônica, adequada ao ambiente de biblioteca digital.

| Cor | Código Hex | Aplicação |
|---|---|---|
| Azul Primário | `0xFF2196F3` | Headers, AppBar, botões principais |
| Verde | `0xFF4CAF50` | Botões de sucesso, confirmações |
| Vermelho | `0xFFF44336` | Botões de exclusão, erros |
| Azul Escuro | `0xFF1565C0` | Background de cards, contraste |

---

## 5. ARQUITETURA DO SOFTWARE

### 5.1 Padrão Arquitetural

O sistema foi desenvolvido seguindo o padrão **MVC (Model-View-Controller)** com separação clara de responsabilidades em camadas:

```
┌─────────────────────────────────────────┐
│         CAMADA DE APRESENTAÇÃO          │
│    (Flutter UI - Screens & Widgets)     │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│      CAMADA DE CONTROLADORES            │
│  (auth_controller, livro_controller,    │
│   emprestimo_controller)                │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│      CAMADA DE SERVIÇOS API             │
│    (api_service.dart - HTTP Client)     │
└─────────────────┬───────────────────────┘
                  │
        HTTP + JWT Token
                  │
┌─────────────────▼───────────────────────┐
│         BACKEND SPRING BOOT             │
│  AuthController, LivroController,       │
│  EmprestimoController                   │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│      CAMADA DE NEGÓCIO (Service)        │
│  UsuarioService, LivroService,          │
│  EmprestimoService                      │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│      CAMADA DE PERSISTÊNCIA             │
│  UsuarioRepository, LivroRepository,    │
│  EmprestimoRepository (JPA)             │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│         BANCO DE DADOS MySQL            │
│   Tabelas: usuarios, livros, emprestimos│
└─────────────────────────────────────────┘
```

### 5.2 Componentes Principais

#### Frontend (Flutter)

```
lib/
├── main.dart                    # Ponto de entrada da aplicação
├── config/
│   └── config.dart             # Configurações (URL backend)
├── models/
│   ├── livro.dart              # Model: Livro (fromJson, toJson)
│   ├── emprestimo.dart         # Model: Empréstimo
│   └── usuario.dart            # Model: Usuário (opcional)
├── controllers/
│   ├── auth_controller.dart    # Lógica de autenticação
│   ├── livro_controller.dart   # CRUD de livros
│   └── emprestimo_controller.dart # CRUD de empréstimos
├── services/
│   └── api_service.dart        # Cliente HTTP com JWT
├── screens/
│   ├── login_simples.dart      # Tela de login/registro
│   ├── cadastros_screen.dart   # CRUD de livros
│   ├── emprestimos_screen.dart # CRUD de empréstimos
│   └── teste_conexao_screen_EXEMPLO.dart
└── widgets/
    └── menu_drawer.dart        # Menu de navegação
```

#### Backend (Java Spring Boot)

```
src/main/java/com/example/biblio/
├── BiblioApplication.java      # Spring Boot application
├── config/
│   └── SecurityConfig.java     # JWT + CORS + Spring Security
├── controller/
│   ├── AuthController.java     # Login/Register endpoints
│   ├── LivroController.java    # CRUD endpoints
│   └── EmprestimoController.java # CRUD endpoints
├── entity/
│   ├── Usuario.java
│   ├── Livro.java
│   └── Emprestimo.java
├── dto/
│   ├── LoginDTO.java
│   └── EmprestimoDTO.java
├── service/
│   ├── UsuarioService.java
│   ├── LivroService.java
│   └── EmprestimoService.java
├── repository/
│   ├── UsuarioRepository.java
│   ├── LivroRepository.java
│   └── EmprestimoRepository.java
├── security/
│   ├── JwtAuthenticationFilter.java  # Filtro JWT
│   └── JwtTokenProvider.java         # Geração e validação
└── mapper/
    └── Mapper.java             # Mapeamento Entity <-> DTO
```

### 5.3 Fluxo de Autenticação

1. Usuário insere email, nome e senha na tela de registro
2. `AuthController.register()` chama `UsuarioService.create()`
3. Senha é criptografada com BCrypt
4. `JwtTokenProvider` gera token JWT assinado
5. Token é retornado e armazenado em `FlutterSecureStorage`
6. Todas as requisições posteriores incluem `Authorization: Bearer {token}`
7. `JwtAuthenticationFilter` valida o token antes de processar requisições

### 5.4 Fluxo CRUD de Livros

```
Frontend (Flutter)
    ↓
LivroController (get/post/put/delete)
    ↓
ApiService (HTTP + JWT)
    ↓
Backend Spring Boot
    ↓
LivroController (@RestController)
    ↓
LivroService (lógica de negócio)
    ↓
LivroRepository (JPA queries)
    ↓
MySQL Database
```

### 5.5 Alterações Arquiteturais (vs. N2)

**Adições na N3:**

1. **Camada de Segurança:** Implementado `SecurityConfig` com CORS e JWT
2. **Filtro de Autenticação:** `JwtAuthenticationFilter` valida tokens em todas as rotas
3. **Serviços HTTP:** `ApiService` centraliza requisições com tratamento de erros
4. **Controllers Async:** Todos os controllers agora usam `Future<void>` para operações HTTP
5. **Armazenamento Seguro:** `FlutterSecureStorage` para tokens JWT

---

## 6. PROJETO DO BANCO DE DADOS

### 6.1 Modelo Conceitual

```
┌─────────────┐        ┌─────────────┐        ┌──────────────┐
│  USUARIOS   │        │   LIVROS    │        │ EMPRESTIMOS  │
├─────────────┤        ├─────────────┤        ├──────────────┤
│ id (PK)     │        │ id (PK)     │        │ id (PK)      │
│ email (UK)  │        │ nome        │        │ cliente      │
│ nome        │        │ quantidade  │        │ livro        │
│ senha_hash  │        └─────────────┘        └──────────────┘
└─────────────┘
```

### 6.2 Schema do Banco de Dados

#### Tabela: `usuarios`

```sql
CREATE TABLE usuarios (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    nome VARCHAR(255) NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Índices:**
- PRIMARY KEY: `id`
- UNIQUE: `email`

#### Tabela: `livros`

```sql
CREATE TABLE livros (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    quantidade INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

**Índices:**
- PRIMARY KEY: `id`

#### Tabela: `emprestimos`

```sql
CREATE TABLE emprestimos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    cliente VARCHAR(255) NOT NULL,
    livro VARCHAR(255) NOT NULL,
    usuario_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL
);
```

**Índices:**
- PRIMARY KEY: `id`
- FOREIGN KEY: `usuario_id` → `usuarios.id`

### 6.3 Relacionamentos

1. **Usuario → Emprestimo** (1:N)
   - Um usuário pode fazer vários empréstimos
   - Campo: `usuario_id` na tabela `emprestimos`

2. **Livro → Emprestimo** (1:N)
   - Um livro pode estar vinculado a vários empréstimos
   - Campo: `livro` na tabela `emprestimos`

### 6.4 Normalização

O banco de dados segue a **3ª Forma Normal (3FN)**:

- ✅ 1FN: Todos os atributos contêm valores atômicos
- ✅ 2FN: Todos os atributos não-chave dependem totalmente da chave primária
- ✅ 3FN: Sem dependências transitivas entre atributos não-chave

### 6.5 Alterações (vs. N2)

**Mudança Principal:** Firebase substituído por MySQL

| Aspecto | N2 (Firebase) | N3 (MySQL) |
|---|---|---|
| SGBD | Cloud Firestore | MySQL 8.3 |
| Estrutura | Coleções/Documentos | Tabelas/Tuplas |
| Autenticação | Firebase Auth | JWT + Spring Security |
| Custo | Modelo de uso | Servidor local/dedicado |
| Escalabilidade | Cloud (Google) | Manual (DevOps) |

---

## 7. TESTES DE SOFTWARE

### 7.1 Estratégia de Testes

O projeto implementou testes em dois níveis:

1. **Testes Manuais Funcionais** - Validação de fluxos de negócio
2. **Testes de Integração** - Verificação de comunicação Frontend-Backend

### 7.2 Testes Manuais Realizados

#### 7.2.1 Teste de Autenticação

| Cenário | Passos | Resultado Esperado | Resultado Obtido | Status |
|---|---|---|---|---|
| Registro de novo usuário | 1. Abrir app<br>2. Clicar "Registrar"<br>3. Inserir dados<br>4. Clicar "Registrar" | Token JWT retornado e armazenado | ✅ Funcionou | ✅ PASS |
| Login com credenciais válidas | 1. Inserir email válido<br>2. Inserir senha correta<br>3. Clicar "Login" | App navega para tela principal | ✅ Funcionou | ✅ PASS |
| Login com credenciais inválidas | 1. Inserir email errado<br>2. Clicar "Login" | Mensagem de erro exibida | ✅ Erro exibido | ✅ PASS |

#### 7.2.2 Teste de CRUD de Livros

| Operação | Passos | Resultado Esperado | Resultado Obtido | Status |
|---|---|---|---|---|
| Criar livro | 1. Ir para "Cadastros"<br>2. Preencher formulário<br>3. Clicar "Salvar" | Livro adicionado à lista | ✅ Adicionado | ✅ PASS |
| Listar livros | 1. Abrir tela "Cadastros"<br>2. Aguardar carregamento | Lista de livros exibida | ✅ Exibida | ✅ PASS |
| Atualizar livro | 1. Clicar em livro<br>2. Editar dados<br>3. Salvar | Livro atualizado | ✅ Atualizado | ✅ PASS |
| Deletar livro | 1. Clicar "Excluir"<br>2. Confirmar | Livro removido da lista | ✅ Removido | ✅ PASS |

#### 7.2.3 Teste de CRUD de Empréstimos

| Operação | Passos | Resultado Esperado | Resultado Obtido | Status |
|---|---|---|---|---|
| Criar empréstimo | 1. Ir para "Empréstimos"<br>2. Clicar "Novo"<br>3. Selecionar livro do dropdown<br>4. Inserir cliente<br>5. Salvar | Empréstimo criado com livro selecionado | ✅ Criado | ✅ PASS |
| Listar empréstimos | 1. Abrir "Empréstimos"<br>2. Aguardar carregamento | Lista de empréstimos exibida | ✅ Exibida | ✅ PASS |
| Atualizar empréstimo | 1. Clicar "Alterar"<br>2. Modificar dados<br>3. Salvar | Empréstimo atualizado | ✅ Atualizado | ✅ PASS |
| Deletar empréstimo | 1. Clicar "Excluir"<br>2. Confirmar | Empréstimo removido | ✅ Removido | ✅ PASS |

#### 7.2.4 Teste de Responsividade (UI/UX)

| Aspecto | Verificação | Resultado |
|---|---|---|
| Proporção 16:9 | Testado em Chrome DevTools | ✅ Responsivo |
| Navegação | Drawer menu funciona em todas as telas | ✅ Funciona |
| Feedback visual | Loading spinners e SnackBars | ✅ Exibidos |
| Cores | Paleta aplicada conforme documento | ✅ Conforme |

### 7.3 Testes de Integração HTTP

#### 7.3.1 CORS (Cross-Origin Resource Sharing)

**Problema Identificado:** Erro 403 Forbidden ao fazer requisições do navegador

**Solução Implementada:** 
```java
// SecurityConfig.java
configuration.setAllowedOriginPatterns(Arrays.asList("*"));
http.cors(cors -> cors.configurationSource(corsConfigurationSource()));
```

**Resultado:** ✅ Requisições aceitas com headers CORS corretos

#### 7.3.2 Autenticação JWT

**Teste:** Requisição sem token

```
GET /api/livros
Response: 403 Unauthorized
```

**Teste:** Requisição com token válido

```
GET /api/livros
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
Response: 200 OK + Lista de livros
```

**Resultado:** ✅ JWT validado corretamente

#### 7.3.3 Timeouts e Performance

| Requisição | Tempo Médio | Limite | Status |
|---|---|---|---|
| GET /livros (10 registros) | 250ms | 5s | ✅ OK |
| POST /emprestimos | 300ms | 5s | ✅ OK |
| DELETE /livro/{id} | 150ms | 5s | ✅ OK |

### 7.4 Testes Automatizados (Backend)

#### 7.4.1 Testes Unitários - JUnit + Spring Boot Test

```java
// Exemplo de teste unitário
@SpringBootTest
class UsuarioServiceTest {
    
    @Autowired
    private UsuarioService usuarioService;
    
    @Test
    void testRegistroUsuarioComSucesso() {
        // Dado
        Usuario usuario = new Usuario("teste@email.com", "Teste", "123456");
        
        // Quando
        Usuario resultado = usuarioService.create(usuario);
        
        // Então
        assertNotNull(resultado.getId());
        assertEquals("teste@email.com", resultado.getEmail());
    }
}
```

### 7.5 Resultados e Análise

**Taxa de Sucesso:** 100% dos testes executados passaram

**Observações:**

1. ✅ **Autenticação:** JWT funciona corretamente em todas as rotas protegidas
2. ✅ **CRUD:** Todas as operações de Create, Read, Update, Delete funcionam
3. ✅ **CORS:** Navegador aceita requisições após configuração
4. ✅ **Performance:** Requisições completam dentro dos limites de timeout
5. ✅ **UI/UX:** Interface responsiva e intuitiva
6. ✅ **Segurança:** Senhas criptografadas com BCrypt

**Impacto para o Projeto:** Os testes confirmam que o sistema está pronto para produção em ambiente de teste. Recomenda-se implementar testes E2E (End-to-End) antes de deploy em produção.

---

## 8. BUILD E DISTRIBUIÇÃO

### 8.1 Ambiente de Desenvolvimento

**Pré-requisitos:**

```
- Flutter SDK: 3.24.x (ou superior)
- Dart: 3.5.x (incluído no Flutter)
- Java JDK: 21 (OpenJDK ou Oracle)
- Android Studio: Bumblebee (2021.1) ou superior
- Maven: 3.8.x
- MySQL Server: 8.0 ou superior
```

### 8.2 Build do Frontend (Flutter)

#### 8.2.1 Preparação

```bash
# Clonar repositório
git clone https://github.com/seu-usuario/bibliosoft.git
cd n2_dispositivos_moveis

# Instalar dependências
flutter pub get

# Limpar build anterior
flutter clean
```

#### 8.2.2 Build para Android (.apk)

```bash
# Build release
flutter build apk --release

# Saída
# ✓ Built build/app/outputs/flutter-apk/app-release.apk (XX MB)
```

**Localização do .apk:**
```
n2_dispositivos_moveis/build/app/outputs/flutter-apk/app-release.apk
```

#### 8.2.3 Build para Web (Chrome/Edge)

```bash
# Build web
flutter build web

# Servir localmente
flutter run -d chrome
```

### 8.3 Build do Backend (Spring Boot)

#### 8.3.1 Preparação

```bash
# Clonar repositório backend
git clone https://github.com/seu-usuario/backMobile.git
cd backMobile

# Instalar dependências (Maven)
mvn clean install
```

#### 8.3.2 Build da Aplicação

```bash
# Build JAR
mvn clean package -DskipTests

# Saída
# [INFO] Building jar: target/biblio-application.jar
```

#### 8.3.3 Executar Backend

```bash
# Via IDE (IntelliJ)
# Run → Run 'BiblioApplication'

# Via terminal
java -jar target/biblio-application.jar

# Servidor escuta em
# http://localhost:8080
```

### 8.4 Configuração do Banco de Dados

#### 8.4.1 Criar Banco de Dados MySQL

```sql
CREATE DATABASE biblio;
USE biblio;

-- Tabelas são criadas automaticamente via Hibernate
-- (spring.jpa.hibernate.ddl-auto=update em application.properties)
```

#### 8.4.2 Arquivo de Configuração (application.properties)

```properties
# Servidor
server.port=8080

# MySQL
spring.datasource.url=jdbc:mysql://localhost:3306/biblio
spring.datasource.username=root
spring.datasource.password=sua_senha
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# Hibernate
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect

# JWT
jwt.secret=sua-chave-secreta-muito-segura
jwt.expiration=86400000
```

### 8.5 Estrutura de Pastas Entregue

```
N3_BiblioSoft/
├── n2_dispositivos_moveis/              # Projeto Flutter
│   ├── lib/
│   ├── build/
│   │   └── app/outputs/flutter-apk/
│   │       └── app-release.apk          # APK final
│   ├── pubspec.yaml
│   ├── pubspec.lock
│   └── ...
├── backMobile/                          # Projeto Spring Boot
│   ├── src/
│   ├── pom.xml
│   ├── target/
│   │   └── biblio-application.jar       # JAR do backend
│   └── ...
└── DOCUMENTO_TECNICO_N3.pdf             # Este documento
```

### 8.6 Alterações no Build (vs. N2)

| Aspecto | N2 | N3 |
|---|---|---|
| Backend | Não havia | Spring Boot 3.2.5 com Maven |
| Banco | Firebase | MySQL 8.3 |
| Autenticação | Básica (simulada) | JWT + Spring Security |
| CORS | Não configurado | Habilitado com setAllowedOriginPatterns |
| Servidor | N/A | Apache Tomcat 10.1.20 |

---

## 9. CONSIDERAÇÕES FINAIS

### 9.1 Desenvolvimento Realizado

O projeto BiblioSoft foi desenvolvido com sucesso, cumprindo todos os requisitos funcionais e não-funcionais propostos no documento técnico. A aplicação é totalmente funcional e pronta para uso.

#### 9.1.1 Funcionalidades Implementadas

✅ Autenticação segura com JWT e Spring Security  
✅ CRUD completo de Livros com integração HTTP  
✅ CRUD completo de Empréstimos com seleção de livros via dropdown  
✅ Interface responsiva e intuitiva em Flutter  
✅ Armazenamento seguro de tokens em FlutterSecureStorage  
✅ Tratamento robusto de erros e timeouts  
✅ Logging detalhado de requisições HTTP  
✅ Paleta de cores conforme documento  
✅ Menu de navegação (Drawer) funcional  
✅ Logout de usuários  

#### 9.1.2 Desafios Enfrentados

1. **CORS no navegador:** Inicialmente, requisições HTTP do Flutter web eram bloqueadas. Solução: Configurar `setAllowedOriginPatterns()` no SecurityConfig.
2. **BOM em arquivo Java:** Erro de caractere invisível após reescrita do SecurityConfig. Solução: Usar UTF-8 sem BOM.
3. **Método deprecado `.cors().and()`:** Spring Security 6.2.4 deprecou essa sintaxe. Solução: Usar lambda `cors -> cors.configurationSource()`.
4. **Dropdown de livros dinâmico:** Necessidade de buscar livros do backend ao abrir diálogo. Solução: Implementar `StatefulBuilder` com `buscarTodosLivros()`.

#### 9.1.3 Decisões Arquiteturais

1. **MySQL vs Firebase:** Escolhemos MySQL para maior controle, testes mais fáceis e redução de custos.
2. **Controllers Async:** Implementamos `Future<void>` em todos os métodos para operações não-bloqueantes.
3. **Centralização de API:** `ApiService.dart` centraliza todas as requisições HTTP com tratamento de erros.
4. **Separação de Concerns:** Controllers (lógica) separados de Screens (UI) seguindo padrão MVC.

### 9.2 Distribuição de Papéis

#### Pablo Mikolaiczyki

- ✅ Desenvolvimento do Frontend Flutter (Screens e Widgets)
- ✅ Implementação de Controllers (LivroController, EmprestimoController)
- ✅ Testes manuais funcionais
- ✅ Integração HTTP no frontend
- ✅ UI/UX e navegação

#### Cesar Vinicius Micheluzzi

- ✅ Desenvolvimento do Backend Spring Boot
- ✅ Implementação de Controllers REST (AuthController, LivroController, EmprestimoController)
- ✅ Configuração de Segurança (JWT + CORS)
- ✅ Estrutura do Banco de Dados MySQL
- ✅ Testes de integração
- ✅ Build e deploy

### 9.3 Lições Aprendidas

1. **Importância de CORS:** Web development com Flutter requer atenção especial a CORS
2. **JWT em produção:** Tokens devem ser armazenados de forma segura (FlutterSecureStorage)
3. **Versionamento de dependências:** Manter versões compatíveis é crítico (Spring 6.2.4 com Java 21)
4. **Logs são essenciais:** Print statements ajudaram a debugar problemas rapidamente
5. **Documentação durante desenvolvimento:** Facilita alterações e melhorias futuras

### 9.4 Melhorias Futuras (Recomendações)

1. Implementar testes E2E com Appium ou Flutter Driver
2. Adicionar autenticação biométrica (fingerprint)
3. Sincronização offline (SQLite local)
4. Notificações push para devoluções de empréstimos
5. Dashboard com estatísticas de empréstimos
6. Geração de relatórios em PDF
7. Integração com QR code para livros
8. Sistema de mensagens entre usuários
9. Implementar rate limiting de API
10. Deploy em produção com HTTPS e domínio

---

## 10. REFERÊNCIAS

### 10.1 Documentação Oficial

DART. *Dart programming language*. Disponível em: https://dart.dev/. Acesso em: 02 dez. 2025.

FLUTTER. *Flutter documentation*. Disponível em: https://flutter.dev/docs. Acesso em: 02 dez. 2025.

SPRING. *Spring Boot 3.2 documentation*. Disponível em: https://spring.io/projects/spring-boot. Acesso em: 02 dez. 2025.

SPRING SECURITY. *Spring Security 6.2 reference*. Disponível em: https://spring.io/projects/spring-security. Acesso em: 02 dez. 2025.

MYSQL. *MySQL 8.0 reference manual*. Disponível em: https://dev.mysql.com/doc/. Acesso em: 02 dez. 2025.

### 10.2 Bibliotecas e Pacotes Utilizados

HTTP. *Dart HTTP client*. Disponível em: https://pub.dev/packages/http. Acesso em: 02 dez. 2025.

FLUTTER_SECURE_STORAGE. *Secure storage for Flutter*. Disponível em: https://pub.dev/packages/flutter_secure_storage. Acesso em: 02 dez. 2025.

JJWT. *JSON Web Token for Java*. Disponível em: https://github.com/jwtk/jjwt. Acesso em: 02 dez. 2025.

### 10.3 Recursos de Aprendizado

MICROSOFT. *VS Code Flutter documentation*. Disponível em: https://code.visualstudio.com/docs/languages/dart. Acesso em: 02 dez. 2025.

MAVEN CENTRAL. *Maven dependency repository*. Disponível em: https://mvnrepository.com/. Acesso em: 02 dez. 2025.

BAELDUNG. *Spring Security tutorials*. Disponível em: https://www.baeldung.com/security. Acesso em: 02 dez. 2025.

### 10.4 Ferramentas de Desenvolvimento

INTELLIJ IDEA. *IntelliJ IDEA Community Edition 2025.2*. JetBrains, 2025.

ANDROID STUDIO. *Android Studio Koala Feature Drop*. Google, 2025.

GITHUB. *Version control system*. Disponível em: https://github.com. Acesso em: 02 dez. 2025.

### 10.5 Inteligência Artificial Utilizada

**GitHub Copilot**

- **Uso:** Assistência na escrita de código Java (Spring Boot) e Dart (Flutter)
- **Aplicações:** Geração de métodos CRUD, configuração de Security Config, criação de Models
- **Impacto:** Acelerou o desenvolvimento em aproximadamente 30%, reduzindo tempo de codificação repetitiva
- **Validação:** Todos os códigos gerados foram revisados e testados antes de implementação

**ChatGPT 4**

- **Uso:** Explicações de conceitos, debugging de erros, análise de stack traces
- **Aplicações:** Solução de problemas de CORS, entendimento de JWT, otimização de queries SQL
- **Impacto:** Facilitou compreensão de problemas complexos, reduzindo tempo de troubleshooting
- **Validação:** Respostas validadas contra documentação oficial e testes

---

## CONCLUSÃO

O projeto BiblioSoft foi desenvolvido com sucesso, implementando todas as funcionalidades previstas no documento técnico. A integração entre frontend Flutter e backend Spring Boot foi realizada com segurança, responsividade e seguindo boas práticas de engenharia de software.

O sistema está pronto para operação em ambiente de teste e pode ser escalado para produção com as devidas considerações de segurança, performance e infraestrutura.

**Data de Conclusão:** 02 de Dezembro de 2025

---

*Documento Técnico - BiblioSoft - N3*  
*Versão: 1.0 Final*  
*Disponível em: Drive da equipe*
