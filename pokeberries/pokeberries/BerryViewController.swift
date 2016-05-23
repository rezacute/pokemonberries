//
//  BerryViewController.swift
//  pokeberries
//
//  Created by syahRiza on 5/19/16.
//  Copyright © 2016 reza. All rights reserved.
//

import UIKit
import Charts
import Material
import RealmSwift
class TriangeView : UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override func drawRect(rect: CGRect) {

        let ctx : CGContextRef = UIGraphicsGetCurrentContext()!

        CGContextBeginPath(ctx)
        CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect))
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect))
        CGContextAddLineToPoint(ctx, (CGRectGetMaxX(rect)/2.0), CGRectGetMinY(rect))
        CGContextClosePath(ctx)

        CGContextSetRGBFillColor(ctx, 1.0, 1, 1, 1);
        CGContextFillPath(ctx);
    }
}

class BerryViewController: UIViewController, ChartViewDelegate {

    var idx = 0
    var max = 2

    @IBOutlet weak var chartView: RadarChartView!
    var pBerry : Berry?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Berry Radar Chart"
        guard let realm = try? Realm() else {
            return
        }

        let berries = realm.objects(Berry)
        if  berries.count == 0 {
            return
        }
        pBerry = berries[0]
        max = berries.count


        prepareChart()
        chartView.setNeedsLayout()
        chartView.layoutIfNeeded()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var cardView : CardView?
    // Title label.
    let titleLabel: UILabel = UILabel()
    func defineButtons(){
        if idx > 0 {
            let btn1: FlatButton = FlatButton()
            btn1.pulseColor = MaterialColor.blue.lighten1
            btn1.setTitle("PREV", forState: .Normal)
            btn1.setTitleColor(MaterialColor.blue.darken1, forState: .Normal)
            btn1.addTarget(self, action: #selector(BerryViewController.prev(_:)), forControlEvents: .TouchUpInside)
            // Add buttons to left side.
            cardView?.leftButtons = [btn1]
        }else{
            cardView?.leftButtons = []
        }

        if idx < (max - 1) {
            // No button.
            let btn2: FlatButton = FlatButton()
            btn2.pulseColor = MaterialColor.blue.lighten1
            btn2.setTitle("NEXT", forState: .Normal)
            btn2.addTarget(self, action: #selector(BerryViewController.next(_:)), forControlEvents: .TouchUpInside)

            btn2.setTitleColor(MaterialColor.blue.darken1, forState: .Normal)
            cardView?.rightButtons = [btn2]
            
        }else{
            cardView?.rightButtons = []
        }

    }
    let detailLabel: UILabel = UILabel()
    override func viewDidAppear(animated: Bool) {

        let triangle = TriangeView(frame: CGRectMake((self.view.frame.size.width/2), (chartView.frame.size.height)+5, 25, 15))
        triangle.backgroundColor = UIColor.clearColor()
        self.view.addSubview(triangle)
        chartView.layer.shadowColor = MaterialColor.lightGreen.lighten1.CGColor
        chartView.layer.shadowOpacity = 1
        chartView.layer.shadowOffset = CGSizeZero
        chartView.layer.shadowRadius = 10
        let cardView: CardView = CardView(frame: CGRectMake(5, (chartView.frame.size.height)+20, chartView.frame.size.width + 10, 150))


        titleLabel.text = pBerry?.name.capitalizedString
        titleLabel.textColor = MaterialColor.blue.darken1
        titleLabel.font = RobotoFont.mediumWithSize(20)


        // Detail label.

        if let giftPower = pBerry?.naturalGiftPower {
            detailLabel.text = "Natural Gift Power : \(giftPower)"
        }

        detailLabel.numberOfLines = 0


        self.cardView = cardView
        Manager.sharedInstance.completionBlock = {
            dispatch_async(dispatch_get_main_queue(), {
                guard let realm = try? Realm() else {
                    return
                }

                let berries = realm.objects(Berry)
                if  berries.count == 0 {
                    return
                }
                self.pBerry = berries[0]
                self.max = berries.count
                self.titleLabel.text = self.pBerry?.name.capitalizedString
                cardView.titleLabel = self.titleLabel
                if let giftPower = self.pBerry?.naturalGiftPower {
                    self.detailLabel.text = "Natural Gift Power : \(giftPower)"
                }
                cardView.shadowOpacity = 0.0
                cardView.contentView = self.detailLabel
                self.prepareChart()
                self.defineButtons()
                self.view.addSubview(cardView)
                self.chartView.animate(xAxisDuration: 1, easingOption: .EaseInOutBounce)
            })

        }


    }
    override func viewWillAppear(animated: Bool) {

    }
    func next(sender : UIButton) {
        guard let realm = try? Realm() else {
            return
        }
        idx += 1
        let berries = realm.objects(Berry)
        max = berries.count
        pBerry = berries[idx]
        prepareChart()
        defineButtons()
        titleLabel.text = pBerry?.name.capitalizedString
        if let giftPower = pBerry?.naturalGiftPower {
            detailLabel.text = "Natural Gift Power : \(giftPower)"
        }
    }

    func prev(sender : UIButton) {
        guard let realm = try? Realm() else {
            return
        }
        idx -= 1
        let berries = realm.objects(Berry)
        pBerry = berries[idx]
        max = berries.count
        prepareChart()
        defineButtons()
        titleLabel.text = pBerry?.name.capitalizedString
        if let giftPower = pBerry?.naturalGiftPower {
            detailLabel.text = "Natural Gift Power : \(giftPower)"
        }
    }
    func prepareChart(){
        //chartView.delegate = self;
        chartView.xAxis.labelFont = MaterialFont.boldSystemFontWithSize(12)
        chartView.backgroundColor = MaterialColor.lightGreen.lighten2
        chartView.descriptionText = ""
        chartView.webLineWidth = 0.75;
        chartView.innerWebLineWidth = 0.375
        chartView.webAlpha = 1.0
        chartView.marker = ChartMarker()
        chartView.webColor = MaterialColor.deepOrange.darken1
        chartView.innerWebColor = MaterialColor.deepOrange.darken1
        chartView.yAxis.labelCount = 3;
        chartView.yAxis.axisMinValue = 0.0;
        if pBerry == nil {
            return
        }

        let yVal = [pBerry!.growthTime,
                    pBerry!.maxHarvest,
                    pBerry!.size,
                    pBerry!.smoothness,
                    pBerry!.soilDryness]
        let xVal = ["growth_time","max_harvest","size","smoothness","soil_dryness"]
        let set = RadarChartDataSet(yVals: yVal.enumerate().map { (index, element) in
            return ChartDataEntry(value: Double(element), xIndex: index)
            }, label: "Berry profile")

        set.colors = [MaterialColor.blue.darken1]
        
        chartView.data = RadarChartData(xVals: xVal, dataSets: [set])

    }

}
