import os

from django.core.asgi import get_asgi_application

os.environ.setdefault(
    "DJANGO_SETTINGS_MODULE",
    "carpolling.settings"
)

# Initialise Django (loads settings + populates the app registry) BEFORE
# importing anything that touches models. locations.routing -> consumers imports
# rides.models, and locations.middleware imports oauth2_provider.models; doing
# those imports first raises ImproperlyConfigured / AppRegistryNotReady.
django_asgi_app = get_asgi_application()

from channels.routing import ProtocolTypeRouter, URLRouter  # noqa: E402
from locations.routing import websocket_urlpatterns  # noqa: E402
from locations.middleware import OAuthTokenMiddleware  # noqa: E402


application = ProtocolTypeRouter({

    "http": django_asgi_app,

    "websocket": OAuthTokenMiddleware(
        URLRouter(
            websocket_urlpatterns
        )
    ),

})