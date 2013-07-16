# vim:set sts=4 sw=4 tw=0:

from gi.repository import IBus

class IMEStatus:

    BUS = IBus.Bus()
    IC = IBus.InputContext.get_input_context(
            BUS.current_input_context(),
            BUS.get_connection())

    @staticmethod
    def ic():
        return IMEStatus.IC

    @staticmethod
    def get():
        if IMEStatus.ic().is_enabled():
            return 1
        else:
            return 0

    @staticmethod
    def set(v):
        if v:
            IMEStatus.ic().enable()
        else:
            IMEStatus.ic().disable()
        return 0
