# vim:set sts=4 sw=4 tw=0 et:

from gi.repository import IBus

class IBusPy:
    BUS = IBus.Bus()

    @staticmethod
    def _ic():
        bus = IBusPy.BUS
        path = bus.current_input_context()
        conn = bus.get_connection()
        return IBus.InputContext.get_input_context(path, conn)

    @staticmethod
    def get():
        ic = IBusPy._ic()
        return 1 if ic.is_enabled() else 0

    @staticmethod
    def set(v):
        ic = IBusPy._ic()
        if v:
            ic.enable()
        else:
            ic.disable()
        return 0
