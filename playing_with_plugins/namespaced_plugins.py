import inspect
from importlib.metadata import version, entry_points, EntryPoints


def get_and_validate_plugins() -> EntryPoints:
    """Get the entry points for all plugins

    :rtype: EntryPoints
    :return: The entry points for all plugins
    """
    function_name = inspect.currentframe().f_code.co_name

    filter_plugins = entry_points(group="gestalt.plugins")

    for plugin in filter_plugins:
        loaded_plugin = plugin.load()
        if not hasattr(loaded_plugin, "get_registered_filters"):
            error = (
                f"function: {function_name}  filter_plugin: {plugin.value} version: {version(plugin.value)} "
                f"has no FilterModule class"
            )
            print(error)
            raise RuntimeError(error)

    return filter_plugins


def get_plugins_loaded() -> None:
    """Get the Jinja2 Rendering environment with loaded plugins

    :rtype: Environment
    :return: The Jinja2 Rendering environment
    """

    for plugin in get_and_validate_plugins():
        loaded_plugin = plugin.load()
        loaded_plugin.get_registered_filters()
