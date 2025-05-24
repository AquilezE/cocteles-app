import 'package:cocteles_app/features/livestreams/models/livestream_model.dart';
import 'package:cocteles_app/features/perzonalization/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart'; // Provides [Player], [Media], [Playlist] etc.
import 'package:media_kit_video/media_kit_video.dart'; // Provides [VideoController] & [Video] etc.
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LivestreamScreen extends StatefulWidget {
  final LivestreamModel livestreamModel;

  const LivestreamScreen({super.key, required this.livestreamModel});
  @override
  State<LivestreamScreen> createState() => _LiveStreamState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Livestream'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 600) {
            return _buildDesktopLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Center(child: Text('Desktop Layout'));
  }

  Widget _buildMobileLayout() {
    return Center(child: Text('Mobile Layout'));
  }
}

class _LiveStreamState extends State<LivestreamScreen> {
  final userController = Get.find<UserController>();

  late final player;
  late final controller;
  late final IO.Socket _socket;
  final RxList<String> messages = <String>[].obs;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _socket = IO.io(
      '${dotenv.env['BASE_URL']}/',
      IO.OptionBuilder()
          .setTransports(['websocket']) // only use WebSocket
          .enableForceNew() // create a fresh connection
          .enableReconnection() // auto-reconnect if dropped
          .setReconnectionAttempts(5) // try up to 5 times
          .setReconnectionDelay(2000) // wait 2s between attempts
          .enableAutoConnect() // connect immediately
          .build(),
    );

    // these can help debug
    _socket.onConnect((_) {
      print('connected');
      _socket.emit('join', widget.livestreamModel.streamKey);
    });
    _socket.onDisconnect((_) => print('disconnected'));

    _socket.on('message:${widget.livestreamModel.streamKey}', (data) {
      print(data);
      final isActvie = data['isActive'] as bool;

      print(isActvie);
      if (isActvie == null) {
        Get.snackbar('Error', 'No se pudo obtener el estado de la transmisión');
        return;
      }
      if (!isActvie) {
        Get.snackbar('Transemisión finalizada', 'La transmisión ha terminado');
        return;
      }

      final incoming = data['text'] as String;
      final userMap = Map<String, dynamic>.from(data['user'] as Map);
      final userId = userMap['id'] as int;
      final username = userMap['username'] as String;

      final display = '$username: $incoming';

      messages.add(display);
    });

    MediaKit.ensureInitialized();
    player = Player();
    controller = VideoController(player);


    print('${dotenv.env['LIVE_URL']}${widget.livestreamModel.streamKey}.m3u8');

    player.open(Media(
        '${dotenv.env['LIVE_URL']}${widget.livestreamModel.streamKey}.m3u8'));
    player.play();
  }

  @override
  void dispose() {
    player.dispose();
    _socket.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();

    _socket.emit('message', {
      'channel': widget.livestreamModel.streamKey,
      'text': text,
      'user': {
        'id': userController.user.value.id,
        'username': userController.user.value.username,
      }
    });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.livestreamModel.title ?? 'Livestream'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back), onPressed: () => Get.back()),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 600) {
            return Row(
              children: [
                Expanded(
                    flex: 3, child: Padding(padding: const EdgeInsets.all(16.0), child: _videoView(constraints.maxWidth * 0.6),), ),
                Expanded(
                    flex: 2,
                    child: ChatDesktop(
                        messages: messages,
                        controller: _messageController,
                        onSend: _sendMessage)),
              ],
            );
          } else {
            // mobile: video arriba, chat debajo
            return SingleChildScrollView(
              child: Column(
                children: [
                  _videoView(constraints.maxWidth),
                  ChatMobile(
                      messages: messages,
                      controller: _messageController,
                      onSend: _sendMessage),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _videoView(double width) {
    final height = width * 9 / 16;
    return Center(
      child: SizedBox(
          width: width, height: height, child: Video(controller: controller)),
    );
  }
}

class ChatDesktop extends StatelessWidget {
  final RxList<String> messages;
  final TextEditingController controller;
  final VoidCallback onSend;
  const ChatDesktop(
      {required this.messages,
      required this.controller,
      required this.onSend,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text('Chat',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Obx(() => ListView.builder(
                itemCount: messages.length,
                itemBuilder: (_, i) => ListTile(title: Text(messages[i])),
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                      controller: controller,
                      decoration:
                          const InputDecoration(hintText: 'Escribe...'))),
              IconButton(icon: const Icon(Icons.send), onPressed: onSend),
            ],
          ),
        ),
      ],
    );
  }
}

class ChatMobile extends StatelessWidget {
  final RxList<String> messages;
  final TextEditingController controller;
  final VoidCallback onSend;
  const ChatMobile(
      {required this.messages,
      required this.controller,
      required this.onSend,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400, // o ajusta según prefieras
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (_, i) => Align(
                    alignment:
                        Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(messages[messages.length - 1 - i]),
                    ),
                  ),
                )),
          ),
          Row(
            children: [
              Expanded(
                  child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(hintText: 'Mensaje'))),
              IconButton(icon: const Icon(Icons.send), onPressed: onSend),
            ],
          ),
        ],
      ),
    );
  }
}
