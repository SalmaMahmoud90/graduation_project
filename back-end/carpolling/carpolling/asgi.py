import os

from django.core.asgi import get_asgi_application
from channels.routing import ProtocolTypeRouter, URLRouter

from locations.routing import websocket_urlpatterns
from locations.middleware import OAuthTokenMiddleware


os.environ.setdefault(
    "DJANGO_SETTINGS_MODULE",
    "carpolling.settings"
)

django_asgi_app = get_asgi_application()


application = ProtocolTypeRouter({

    "http": django_asgi_app,

    "websocket": OAuthTokenMiddleware(
        URLRouter(
            websocket_urlpatterns
        )
    ),

})