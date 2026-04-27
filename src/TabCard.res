open RecoilAtoms
@react.component
let make = (~paymentOption: PaymentMethodsRecord.paymentFieldsInfo, ~isActive: bool) => {
  let {themeObj, localeString} = Recoil.useRecoilValueFromAtom(configAtom)
  let {readOnly, customMethodNames} = Recoil.useRecoilValueFromAtom(optionAtom)
  let setSelectedOption = Recoil.useSetRecoilState(selectedOptionAtom)
  let isNotAvailable = paymentOption.not_available_reason->Option.isSome
  let (tabClass, tabLabelClass, tabIconClass) = React.useMemo(
    () =>
      isActive && !isNotAvailable
        ? ("Tab--selected", "TabLabel--selected", "TabIcon--selected")
        : ("", "", ""),
    [isActive, isNotAvailable],
  )
  let (displayName, icon) = PaymentUtils.getDisplayNameAndIcon(
    customMethodNames,
    paymentOption.paymentMethodName,
    paymentOption.displayName,
    paymentOption.icon,
  )
  let onClick = _ => {
    if !isNotAvailable {
      setSelectedOption(_ => paymentOption.paymentMethodName)
    }
  }
  <button
    className={`Tab ${tabClass} flex flex-col animate-slowShow ${isNotAvailable
        ? "opacity-50 cursor-not-allowed"
        : ""}`}
    type_="button"
    disabled={readOnly || isNotAvailable}
    title={paymentOption.not_available_reason->Option.getOr("")}
    style={
      minWidth: "5rem",
      overflowWrap: "anywhere",
      width: "100%",
      padding: themeObj.spacingUnit,
      cursor: isNotAvailable ? "not-allowed" : "pointer",
    }
    onClick>
    <div className={`TabIcon ${tabIconClass}`}>
      {switch icon {
      | Some(ele) => ele
      | None => <Icon name="default-card" size=19 />
      }}
    </div>
    <div className={`TabLabel ${tabLabelClass}`}>
      {React.string(paymentOption.paymentMethodName === "card" ? localeString.card : displayName)}
    </div>
  </button>
}
