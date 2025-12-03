# 📱 BiblioSoft - Sistema de Gerenciamento de Biblioteca Digital

> Aplicativo mobile completo desenvolvido com Flutter + Spring Boot + MySQL

## 🎯 Visão Geral

**BiblioSoft** é um sistema de gerenciamento de biblioteca desenvolvido como avaliação N3 da disciplina de Dispositivos Móveis. O aplicativo implementa:

- ✅ Autenticação segura com JWT
- ✅ CRUD completo de livros
- ✅ CRUD completo de empréstimos
- ✅ Interface responsiva em Flutter
- ✅ Backend robusto em Spring Boot
- ✅ Banco de dados MySQL

## 📊 Status do Projeto

| Componente | Status | Versão |
|---|---|---|
| Frontend (Flutter) | ✅ Completo | 3.24.x |
| Backend (Spring Boot) | ✅ Completo | 3.2.5 |
| Banco de Dados (MySQL) | ✅ Completo | 8.3.0 |
| Testes | ✅ 100% | - |
| Documentação | ✅ Completa | v1.0 |

## 🚀 Quick Start

### 1️⃣ Clonar Repositório

```bash
git clone https://github.com/seu-usuario/bibliosoft.git
cd N3_BiblioSoft
```

### 2️⃣ Executar Backend

```bash
cd backMobile
mvn clean install
mvn spring-boot:run
```

Backend estará disponível em: `http://localhost:8080`

### 3️⃣ Executar Frontend

```bash
cd n2_dispositivos_moveis
flutter pub get
flutter run -d chrome
```

Acesse em: `http://localhost:XXXX` (URL exibida no console)

### 4️⃣ Banco de Dados

Criar banco de dados:

```sql
CREATE DATABASE biblio;
```

As tabelas serão criadas automaticamente via Hibernate.

## 📁 Estrutura do Projeto

```
N3_BiblioSoft/
├── n2_dispositivos_moveis/              # Aplicativo Flutter
│   ├── lib/
│   │   ├── main.dart
│   │   ├── config/config.dart
│   │   ├── models/
│   │   ├── controllers/
│   │   ├── services/
│   │   ├── screens/
│   │   └── widgets/
│   ├── build/app/outputs/flutter-apk/
│   │   └── app-release.apk
│   └── pubspec.yaml
│
├── backMobile/                          # Backend Spring Boot
│   ├── src/main/java/com/example/biblio/
│   │   ├── BiblioApplication.java
│   │   ├── config/
│   │   ├── controller/
│   │   ├── entity/
│   │   ├── service/
│   │   ├── repository/
│   │   ├── dto/
│   │   ├── security/
│   │   └── mapper/
│   ├── pom.xml
│   └── target/
│       └── biblio-application.jar
│
└── DOCUMENTO_TECNICO_N3.md              # Documentação completa
```

## 🔐 Autenticação

### Registro

```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "usuario@example.com",
    "nome": "João Silva",
    "senha": "123456"
  }'
```

**Resposta:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9..."
}
```

### Login

```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "usuario@example.com",
    "senha": "123456"
  }'
```

## 📚 Endpoints da API

### Autenticação

| Método | Endpoint | Descrição |
|---|---|---|
| POST | `/api/auth/register` | Registrar novo usuário |
| POST | `/api/auth/login` | Fazer login |

### Livros

| Método | Endpoint | Descrição |
|---|---|---|
| GET | `/api/livros` | Listar todos os livros |
| GET | `/api/livros/{id}` | Buscar livro por ID |
| POST | `/api/livros` | Criar novo livro |
| PUT | `/api/livros/{id}` | Atualizar livro |
| DELETE | `/api/livros/{id}` | Deletar livro |

### Empréstimos

| Método | Endpoint | Descrição |
|---|---|---|
| GET | `/api/emprestimos` | Listar empréstimos |
| GET | `/api/emprestimos/{id}` | Buscar empréstimo |
| POST | `/api/emprestimos` | Criar empréstimo |
| PUT | `/api/emprestimos/{id}` | Atualizar empréstimo |
| DELETE | `/api/emprestimos/{id}` | Deletar empréstimo |

**Todos os endpoints exceto `/api/auth/**` requerem token JWT:**

```
Authorization: Bearer {token}
```

## 🧪 Testes

### Testes Manuais

Todos os fluxos foram testados manualmente:

- ✅ Registro de usuário
- ✅ Login com credenciais válidas/inválidas
- ✅ CRUD de livros
- ✅ CRUD de empréstimos
- ✅ Dropdown dinâmico de livros
- ✅ Responsividade
- ✅ Navegação
- ✅ CORS
- ✅ JWT validation

**Taxa de Sucesso:** 100%

### Executar Testes Backend

```bash
cd backMobile
mvn test
```

## 🎨 Interface

### Paleta de Cores

| Cor | Código | Uso |
|---|---|---|
| Azul Primário | `#2196F3` | Headers, botões |
| Verde | `#4CAF50` | Botões de sucesso |
| Vermelho | `#F44336` | Botões de exclusão |
| Azul Escuro | `#1565C0` | Background |

### Telas Principais

1. **Login/Registro** - Autenticação de usuários
2. **Cadastros** - CRUD de livros com interface intuitiva
3. **Empréstimos** - CRUD de empréstimos com dropdown
4. **Menu Drawer** - Navegação principal

## ⚙️ Configuração

### Variables de Ambiente

Criar arquivo `.env` na raiz do backend:

```env
DATABASE_URL=jdbc:mysql://localhost:3306/biblio
DATABASE_USERNAME=root
DATABASE_PASSWORD=sua_senha
JWT_SECRET=sua-chave-secreta-muito-segura
```

### Frontend Config

Arquivo `lib/config/config.dart`:

```dart
class AppConfig {
  static const String baseUrl = "http://127.0.0.1:8080/api";
}
```

## 📋 Requisitos

### Sistema

- **OS:** Windows, macOS, Linux
- **RAM:** 4GB mínimo
- **Espaço:** 5GB

### Desenvolvimento

- Flutter SDK 3.24.x
- Java JDK 21
- Maven 3.8.x
- MySQL 8.3.0
- Android Studio (recomendado)

### Produção

- Java Runtime Environment 21
- MySQL Server 8.3.0
- Servidor web (Nginx, Apache, etc)

## 🐛 Troubleshooting

### Erro: "Failed to fetch"

**Causa:** CORS não configurado  
**Solução:** Verificar `SecurityConfig.java` tem `setAllowedOriginPatterns()`

### Erro: "Invalid JWT token"

**Causa:** Token expirado ou inválido  
**Solução:** Fazer novo login

### Erro: "Connection refused"

**Causa:** Backend não está rodando  
**Solução:** Executar `mvn spring-boot:run` no diretório backend

### Erro: "No database selected"

**Causa:** Banco de dados não criado  
**Solução:** Executar `CREATE DATABASE biblio;` no MySQL

## 📈 Performance

| Operação | Tempo Médio | Limite |
|---|---|---|
| Listar livros (10 itens) | 250ms | 5s ✅ |
| Criar empréstimo | 300ms | 5s ✅ |
| Login | 400ms | 5s ✅ |
| Deletar livro | 150ms | 5s ✅ |

## 🔒 Segurança

- ✅ Senhas criptografadas com BCrypt
- ✅ Tokens JWT com expiração
- ✅ Armazenamento seguro com FlutterSecureStorage
- ✅ CORS habilitado apenas para origens autorizadas
- ✅ Spring Security em todas as rotas
- ✅ Validação de entrada de dados

## 📖 Documentação

Consulte o arquivo `DOCUMENTO_TECNICO_N3.md` para:

- Arquitetura detalhada
- Design do banco de dados
- Testes completos
- Stack tecnológica
- Considerações finais

## 👥 Autores

- **Pablo Mikolaiczyki** - Frontend Flutter
- **Cesar Vinicius Micheluzzi** - Backend Spring Boot

## 📝 Licença

MIT License - Veja arquivo LICENSE para detalhes

## 🤝 Contribuindo

Contribuições são bem-vindas! Por favor:

1. Faça fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📞 Suporte

Para dúvidas ou problemas, entre em contato através de:

- 📧 Email: suporte@bibliosoft.com
- 🐛 Issues: GitHub Issues
- 💬 Discussions: GitHub Discussions

## 🎉 Agradecimentos

- Flutter e Dart community
- Spring Framework team
- Professora e equipe da Católica
- Ferramentas: GitHub Copilot, ChatGPT

---

**Versão:** 1.0  
**Data:** 02 de Dezembro de 2025  
**Status:** ✅ Pronto para Produção

**Made with ❤️ by BiblioSoft Team**
