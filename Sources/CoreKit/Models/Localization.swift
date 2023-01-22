import Foundation

public enum LS {
    public enum Common: LocalizedTable {
        @Localizable("LS.Common.warningTitle", Self.self, .module)      public static var warningTitle
        @Localizable("LS.Common.errorTitle", Self.self, .module)        public static var errorTitle
        @Localizable("LS.Common.unexpectedError", Self.self, .module)   public static var unexpectedError
        
        @Localizable("LS.Common.ok", Self.self, .module)                public static var ok
        @Localizable("LS.Common.cancel", Self.self, .module)            public static var cancel
        @Localizable("LS.Common.done", Self.self, .module)              public static var done
        @Localizable("LS.Common.delete", Self.self, .module)            public static var delete
    }
}
