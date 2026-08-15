from urllib.parse import parse_qs

from channels.db import database_sync_to_async
from channels.middleware import BaseMiddleware
from django.contrib.auth.models import AnonymousUser

from oauth2_provider.models import AccessToken


class OAuthTokenMiddleware(BaseMiddleware):

    async def __call__(self, scope, receive, send):

        query_string = scope.get("query_string", b"").decode()

        query_params = parse_qs(query_string)

        token = query_params.get("token", [None])[0]

        scope["user"] = await self.get_user(token)

        return await super().__call__(scope, receive, send)

    @database_sync_to_async
    def get_user(self, token):

        if not token:
            return AnonymousUser()

        try:
            access_token = AccessToken.objects.select_related(
                "user"
            ).get(token=token)

        except AccessToken.DoesNotExist:
            return AnonymousUser()

        if access_token.is_expired():
            return AnonymousUser()

        return access_token.user