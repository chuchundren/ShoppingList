//
//  UIControl+Extension.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 07.12.2021.
//

import UIKit

typealias UIControlTargetClosure = (UIControl) -> Void

extension UIControl {
    
    // MARK: - Public functions
    
    func addAction(for event: UIControl.Event,
                   uniqueEvent: Bool = false,
                   action: @escaping UIControlTargetClosure) {
        guard let selector = selectors[event.rawValue] else {
            return
        }
        
        if uniqueEvent {
            clearActions(for: event)
        }
        
        if let closuresWrapper = targetClosure(for: event) {
            closuresWrapper.add(closure: action)
        } else {
            let closuresWrapper = ClosuresWrapper()
            closuresWrapper.add(closure: action)
            setTargetClosure(for: event, closuresWrapper: closuresWrapper)
            addTarget(self, action: selector, for: event)
        }
    }
    
}


// MARK: - Private functions

private extension UIControl {
    
    struct Keys {
        static var eventTouchDown = "eventTouchDown"
        static var eventTouchDownRepeat = "eventTouchDownRepeat"
        static var eventTouchDragInside = "eventTouchDragInside"
        static var eventTouchDragOutside = "eventTouchDragOutside"
        static var eventTouchDragEnter = "eventTouchDragEnter"
        static var eventTouchUpInside = "eventTouchUpInside"
        static var eventTouchUpOutside = "eventTouchUpOutside"
        static var eventTouchCancel = "eventTouchCancel"
        static var eventValueChanged = "eventValueChanged"
        static var eventEditingDidBegin = "eventEditingDidBegin"
        static var eventEditingChanged = "eventEditingChanged"
        static var eventEditingDidEnd = "eventEditingDidEnd"
        static var eventEditingDidEndOnExit = "eventEditingDidEndOnExit"
    }
    
    var selectors: [UInt: Selector] {
        [
            UIControl.Event.touchDown.rawValue: #selector(eventTouchDown),
            UIControl.Event.touchDownRepeat.rawValue: #selector(eventTouchDownRepeat),
            UIControl.Event.touchDragInside.rawValue: #selector(eventTouchDragInside),
            UIControl.Event.touchDragOutside.rawValue: #selector(eventTouchDragOutside),
            UIControl.Event.touchDragEnter.rawValue: #selector(eventTouchDragEnter),
            UIControl.Event.touchUpInside.rawValue: #selector(eventTouchUpInside),
            UIControl.Event.touchUpOutside.rawValue: #selector(eventTouchUpOutside),
            UIControl.Event.touchCancel.rawValue: #selector(eventTouchCancel),
            UIControl.Event.valueChanged.rawValue: #selector(eventValueChanged),
            UIControl.Event.editingDidBegin.rawValue: #selector(eventEditingDidBegin),
            UIControl.Event.editingChanged.rawValue: #selector(eventEditingChanged),
            UIControl.Event.editingDidEnd.rawValue: #selector(eventEditingDidEnd),
            UIControl.Event.editingDidEndOnExit.rawValue: #selector(eventEditingDidEndOnExit)
        ]
    }
    
    func clearActions(for event: UIControl.Event) {
        removeTarget(self, action: nil, for: event)
        setTargetClosure(for: event, closuresWrapper: nil)
    }
    
    // swiftlint:disable:next function_body_length
    func targetClosure(for event: UIControl.Event) -> ClosuresWrapper? {
        // swiftlint:disable closure_body_length
        let closureWrapper: Any? = {
            switch event {
            case .touchDown:
                return objc_getAssociatedObject(self, &Keys.eventTouchDown)
            case .touchDownRepeat:
                return objc_getAssociatedObject(self, &Keys.eventTouchDownRepeat)
            case .touchDragInside:
                return objc_getAssociatedObject(self, &Keys.eventTouchDragInside)
            case .touchDragOutside:
                return objc_getAssociatedObject(self, &Keys.eventTouchDragOutside)
            case .touchDragEnter:
                return objc_getAssociatedObject(self, &Keys.eventTouchDragEnter)
            case .touchUpInside:
                return objc_getAssociatedObject(self, &Keys.eventTouchUpInside)
            case .touchUpOutside:
                return objc_getAssociatedObject(self, &Keys.eventTouchUpOutside)
            case .touchCancel:
                return objc_getAssociatedObject(self, &Keys.eventTouchCancel)
            case .valueChanged:
                return objc_getAssociatedObject(self, &Keys.eventValueChanged)
            case .editingDidBegin:
                return objc_getAssociatedObject(self, &Keys.eventEditingDidBegin)
            case .editingChanged:
                return objc_getAssociatedObject(self, &Keys.eventEditingChanged)
            case .editingDidEnd:
                return objc_getAssociatedObject(self, &Keys.eventEditingDidEnd)
            case .editingDidEndOnExit:
                return objc_getAssociatedObject(self, &Keys.eventEditingDidEndOnExit)
            default:
                return nil
            }
        }()
        
        return closureWrapper as? ClosuresWrapper
    }
    
    // swiftlint:disable:next function_body_length
    func setTargetClosure(for event: UIControl.Event, closuresWrapper: ClosuresWrapper?) {
        switch event {
        case .touchDown:
            objc_setAssociatedObject(
                self,
                &Keys.eventTouchDown,
                closuresWrapper,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        case .touchDownRepeat:
            objc_setAssociatedObject(
                self,
                &Keys.eventTouchDownRepeat,
                closuresWrapper,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        case .touchDragInside:
            objc_setAssociatedObject(
                self,
                &Keys.eventTouchDragInside,
                closuresWrapper,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        case .touchDragOutside:
            objc_setAssociatedObject(
                self,
                &Keys.eventTouchDragOutside,
                closuresWrapper,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        case .touchDragEnter:
            objc_setAssociatedObject(
                self,
                &Keys.eventTouchDragEnter,
                closuresWrapper,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        case .touchUpInside:
            objc_setAssociatedObject(
                self,
                &Keys.eventTouchUpInside,
                closuresWrapper,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        case .touchUpOutside:
            objc_setAssociatedObject(
                self,
                &Keys.eventTouchUpOutside,
                closuresWrapper,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        case .touchCancel:
            objc_setAssociatedObject(
                self,
                &Keys.eventTouchCancel,
                closuresWrapper,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        case .valueChanged:
            objc_setAssociatedObject(
                self,
                &Keys.eventValueChanged,
                closuresWrapper,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        case .editingDidBegin:
            objc_setAssociatedObject(
                self,
                &Keys.eventEditingDidBegin,
                closuresWrapper,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        case .editingChanged:
            objc_setAssociatedObject(
                self,
                &Keys.eventEditingChanged,
                closuresWrapper,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        case .editingDidEnd:
            objc_setAssociatedObject(
                self,
                &Keys.eventEditingDidEnd,
                closuresWrapper,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        case .editingDidEndOnExit:
            objc_setAssociatedObject(
                self,
                &Keys.eventEditingDidEndOnExit,
                closuresWrapper,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        default:
            break
        }
    }
    
    func callActions(for event: UIControl.Event) {
        targetClosure(for: event).flatMap {
            $0.closures.forEach {
                $0(self)
            }
        }
    }
    
    // MARK: Target selectors
    
    @objc
    func eventTouchDown() { callActions(for: .touchDown) }
    
    @objc
    func eventTouchDownRepeat() { callActions(for: .touchDownRepeat) }
    
    @objc
    func eventTouchDragInside() { callActions(for: .touchDragInside) }
    
    @objc
    func eventTouchDragOutside() { callActions(for: .touchDragOutside) }
    
    @objc
    func eventTouchDragEnter() { callActions(for: .touchDragEnter) }
    
    @objc
    func eventTouchUpInside() { callActions(for: .touchUpInside) }
    
    @objc
    func eventTouchUpOutside() { callActions(for: .touchUpOutside) }
    
    @objc
    func eventTouchCancel() { callActions(for: .touchCancel) }
    
    @objc
    func eventValueChanged() { callActions(for: .valueChanged) }
    
    @objc
    func eventEditingDidBegin() { callActions(for: .editingDidBegin) }
    
    @objc
    func eventEditingChanged() { callActions(for: .editingChanged) }
    
    @objc
    func eventEditingDidEnd() { callActions(for: .editingDidEnd) }
    
    @objc
    func eventEditingDidEndOnExit() { callActions(for: .editingDidEndOnExit) }
    
}

private class ClosuresWrapper: NSObject {
    
    var closures = [UIControlTargetClosure]()
    
    func add(closure: @escaping UIControlTargetClosure) {
        closures.append(closure)
    }
    
}
