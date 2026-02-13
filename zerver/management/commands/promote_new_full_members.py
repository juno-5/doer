from typing import Any

from typing_extensions import override

from zerver.actions.user_groups import promote_new_full_members
from zerver.lib.management import DoerBaseCommand, abort_cron_during_deploy, abort_unless_locked


class Command(DoerBaseCommand):
    help = """Add users to full members system group."""

    @override
    @abort_cron_during_deploy
    @abort_unless_locked
    def handle(self, *args: Any, **options: Any) -> None:
        promote_new_full_members()
