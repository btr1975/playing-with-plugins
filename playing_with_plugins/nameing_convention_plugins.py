from typing import List
import importlib
import pkgutil
from pkgutil import ModuleInfo


def get_discovered_plugins(plugin_name_prefix: str) -> List[ModuleInfo]:
    discovered_plugins = []
    for module_info in pkgutil.iter_modules():
        if module_info.name.startswith(plugin_name_prefix):
            discovered_plugins.append(module_info)

    return discovered_plugins


def import_module(module_info: ModuleInfo):
    module = importlib.import_module(module_info.name)
    print(dir(module))
    a = getattr(module, "hello")
    print(a)


for thing in get_discovered_plugins(plugin_name_prefix="temp_"):
    import_module(thing)
