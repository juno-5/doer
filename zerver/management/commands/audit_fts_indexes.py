from typing import Any

from django.db import connection
from typing_extensions import override

from zerver.lib.management import DoerBaseCommand


class Command(DoerBaseCommand):
    @override
    def handle(self, *args: Any, **kwargs: str) -> None:
        with connection.cursor() as cursor:
            cursor.execute(
                """
                UPDATE zerver_message
                SET search_tsvector =
                to_tsvector('doer.english_us_search', subject || rendered_content)
                WHERE to_tsvector('doer.english_us_search', subject || rendered_content) != search_tsvector
            """
            )

            fixed_message_count = cursor.rowcount
            print(f"Fixed {fixed_message_count} messages.")
