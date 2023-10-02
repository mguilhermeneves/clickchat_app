![logo clickchat](readme_images/clickchat_logo.png)

Aplicativo de chat mobile desenvolvido com Flutter e Firebase.

## 🎯 Funcionalidades
- `Autenticação`
  - Criar uma conta para entrar no aplicativo
- `Conversas`
  - Listar conversas
  - Enviar mensagens para os contatos e receber
  - Remover mensagens apenas para um usuário
  - Apagar conversas
- `Contatos`
  - Listar contatos
  - Adicionar, remover e editar um contato
- `Perfil`
  - Tirar, selecionar e remover uma foto para o perfil
  - Sair da conta
- `Notificações`
  - Receber e enviar notificações de mensagens

<!-- ## 📷 Capturas da tela -->
<!-- <p align="center">
<img src="screenshots/1640179162978.png" width="30%">
<img src="screenshots/1640179148024.png" width="30%">
<img src="screenshots/1640179172631.png" width="30%">
</p> -->

## 📝 Arquitetura
- **Repository Pattern:** Para acesso a API externa
- **Dependency Injection:** Resolver dependências das classes (Provider)
- **Controllers:** Guardar e mudar estados (ValueNotifier)
- **Stores:** Guardar e mudar estados (Foi utilizado apenas na feature auth para exemplo)
- **Usecases:** Regras de negócio
- **Push Notification:** (Firebase Cloud Messaging)
- **Tests**

## 📦 Pacotes/Dependências
- [iconsax](https://pub.dev/packages/iconsax)
- [provider](https://pub.dev/packages/provider)
- [http](https://pub.dev/packages/http)
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- [image_picker](https://pub.dev/packages/image_picker)
- [emoji_picker_flutter](https://pub.dev/packages/emoji_picker_flutter)
- [intl](https://pub.dev/packages/intl)
- [cached_network_image](https://pub.dev/packages/cached_network_image)
- [firebase_core](https://pub.dev/packages/firebase_core)
- [firebase_auth](https://pub.dev/packages/firebase_auth)
- [cloud_firestore](https://pub.dev/packages/cloud_firestore)
- [firebase_messaging](https://pub.dev/packages/firebase_messaging)
- [firebase_storage](https://pub.dev/packages/firebase_storage)

dev:
- [mocktail](https://pub.dev/packages/mocktail)
- [fake_cloud_firestore](https://pub.dev/packages/fake_cloud_firestore)

## 👆 Como usar
Primeiro você precisa clonar esse repositório. No terminal:
```terminal
git clone https://github.com/mguilhermeneves/clickchat_app.git
```
Depois instalar as dependências
```terminal
flutter pub get
```

Agora é necessário configurar o Firebase.

1. Criar um projeto do Firebase: https://console.firebase.google.com/

2. Configurar o Firebase no app. Tutorial: https://firebase.google.com/docs/flutter/setup

3. Dentro do projeto no Firebase, vai ser utilizado o Authentication, Cloud Firestore, Messasing e Storage.

4. No Storage do Firebase, criar uma pasta com o nome `pictures`

Após configurar o Firebase, no app, crie o arquivo `cloud_messasing_constant.dart` em ***lib/src/global/constants***. Depois de criado o arquivo, insira o código:
```dart
class CloudMessasingConstant {
  // Esse token está nas Configurações do projeto do Firebase, em 
  // Cloud Messasing (API Cloud Messaging (legada)).
  static const String token = 'CLOUD_MESSASING_TOKEN';
}
```

Agora é só executar o app. No terminal:
```terminal
flutter pub run
```