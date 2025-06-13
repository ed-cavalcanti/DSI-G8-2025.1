# Configuração do Cloudinary para Upload de Imagens

Este projeto utiliza o **Cloudinary** como serviço gratuito para armazenamento de imagens de perfil.

## Passos para Configuração:

### 1. Criar Conta no Cloudinary

1. Acesse: https://cloudinary.com/
2. Clique em "Sign Up for Free"
3. Crie sua conta gratuita

### 2. Obter Credenciais

Após fazer login no Cloudinary:

1. Vá para o Dashboard
2. Anote os seguintes dados:
   - **Cloud Name** (nome da nuvem)
   - **API Key**
   - **API Secret**

### 3. Criar Upload Preset

1. No Dashboard do Cloudinary, vá para "Settings" → "Upload"
2. Role para baixo até "Upload presets"
3. Clique em "Add upload preset"
4. Configure:
   - **Preset name**: `profile_images` (ou outro nome de sua escolha)
   - **Signing mode**: `Unsigned`
   - **Folder**: `profile_images`
   - **Delivery type**: `Upload`
5. Salve o preset

### 4. Configurar o Projeto

Abra o arquivo `lib/services/image_upload_service.dart` e substitua:

```dart
static const String _cloudName = 'SEU_CLOUD_NAME_AQUI';
static const String _uploadPreset = 'SEU_UPLOAD_PRESET_AQUI';
```

Por:

```dart
static const String _cloudName = 'seu_cloud_name_real';
static const String _uploadPreset = 'profile_images'; // ou o nome que você escolheu
```

### 5. Plano Gratuito

O plano gratuito do Cloudinary oferece:

- 25 GB de armazenamento
- 25 GB de bandwidth mensal
- Até 1.000 transformações por mês
- Suporte a imagens e vídeos

### 7. Teste

Após a configuração, teste a funcionalidade:

1. Execute o app
2. Vá para a tela de perfil
3. Toque no avatar ou no ícone da câmera
4. Selecione uma imagem da galeria ou tire uma foto
5. A imagem deve ser enviada para o Cloudinary e atualizada no perfil

## Dicas de Segurança

- O Upload Preset deve ser "Unsigned" para uso em aplicativos móveis
- Nunca exponha sua API Secret no código do app
- Use transformações do Cloudinary para otimizar automaticamente as imagens
