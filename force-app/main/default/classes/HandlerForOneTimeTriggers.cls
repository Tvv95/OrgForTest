public class HandlerForOneTimeTriggers {
    private static Boolean callFlag = true;

    public static Boolean isCallFirstTime() {
        if (callFlag) {
            callFlag = false;
            return true;
        }
        return false;
    }
}
    