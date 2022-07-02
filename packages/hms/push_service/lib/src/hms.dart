part of push_service;

class PushService implements IService {
  @override
  Future<void> init() async {
    Push.getToken('');
  }

  @override
  Future<String?> getToken() async {
    String? token;
    Push.getTokenStream.listen(
      (event) {
        token = event;
      },
      onError: (error) {},
    );
    await Future.delayed(const Duration(milliseconds: 1));
    return token;
  }

  @override
  Future<void> listener<T>({T? plugin}) async {
    // TODO: implement listener
  }

  @override
  Future<void> backgroundHandler() async {
    // TODO: implement backgroundHandler
  }

  @override
  Future<void> onTapWhenAppFon({required Function() onTap}) async {
    // TODO: implement onTapWhenAppFon
  }

  @override
  Future<void> onTapWhenAppClosed({required Function() onTap}) async {
    // TODO: implement onTapWhenAppClosed
  }
}
