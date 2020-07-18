const microclimoz_files = [
    "RH120cm.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92496.1",
    "RH1cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92758.1",
    "RH1cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92759.1",
    "RH1cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92760.1",
    "RH1cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92757.1",
    "SNOWDEP_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92675.1",
    "SNOWDEP_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92676.1",
    "SNOWDEP_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92677.1",
    "SNOWDEP_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92678.1",
    "SOLR.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92487.1",
    "TSKY_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92512.1",
    "TSKY_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92514.1",
    "TSKY_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92515.1",
    "TSKY_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92513.1",
    "Tair120cm.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92526.1",
    "Tair1cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92502.1",
    "Tair1cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92524.1",
    "Tair1cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92525.1",
    "Tair1cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92511.1",
    "V120cm.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92495.1",
    "V1cm.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92497.1",
    "ZEN.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92486.1",
    "ausborder.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92754.1",
    "base_data.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92748.1",
    "hum0cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92681.1",
    "hum0cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92682.1",
    "hum0cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92683.1",
    "hum0cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92684.1",
    "hum100cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92715.1",
    "hum100cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92716.1",
    "hum100cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92717.1",
    "hum100cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92718.1",
    "hum10cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92695.1",
    "hum10cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92696.1",
    "hum10cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92697.1",
    "hum10cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92698.1",
    "hum15cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92699.1",
    "hum15cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92700.1",
    "hum15cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92701.1",
    "hum15cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92703.1",
    "hum2.5cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92687.1",
    "hum2.5cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92688.1",
    "hum2.5cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92689.1",
    "hum2.5cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92690.1",
    "hum200cm.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92680.1",
    "hum20cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92705.1",
    "hum20cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92704.1",
    "hum20cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92706.1",
    "hum20cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92702.1",
    "hum30cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92707.1",
    "hum30cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92708.1",
    "hum30cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92709.1",
    "hum30cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92710.1",
    "hum50cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92711.1",
    "hum50cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92712.1",
    "hum50cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92713.1",
    "hum50cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92714.1",
    "hum5cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92691.1",
    "hum5cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92692.1",
    "hum5cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92693.1",
    "hum5cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92694.1",
    "moist0cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92625.1",
    "moist0cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92626.1",
    "moist0cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92636.1",
    "moist0cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92637.1",
    "moist100cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92670.1",
    "moist100cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92671.1",
    "moist100cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92672.1",
    "moist100cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92673.1",
    "moist10cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92650.1",
    "moist10cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92651.1",
    "moist10cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92652.1",
    "moist10cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92653.1",
    "moist15cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92654.1",
    "moist15cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92655.1",
    "moist15cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92656.1",
    "moist15cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92657.1",
    "moist2.5cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92638.1",
    "moist2.5cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92639.1",
    "moist2.5cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92640.1",
    "moist2.5cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92641.1",
    "moist200cm.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92619.1",
    "moist20cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92658.1",
    "moist20cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92659.1",
    "moist20cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92660.1",
    "moist20cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92661.1",
    "moist30cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92662.1",
    "moist30cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92663.1",
    "moist30cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92664.1",
    "moist30cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92665.1",
    "moist50cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92666.1",
    "moist50cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92667.1",
    "moist50cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92668.1",
    "moist50cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92669.1",
    "moist5cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92644.1",
    "moist5cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92645.1",
    "moist5cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92648.1",
    "moist5cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92649.1",
    "pot0cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92574.1",
    "pot0cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92575.1",
    "pot0cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92576.1",
    "pot0cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92577.1",
    "pot100cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92610.1",
    "pot100cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92628.1",
    "pot100cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92629.1",
    "pot100cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92634.1",
    "pot10cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92570.1",
    "pot10cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92571.1",
    "pot10cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92572.1",
    "pot10cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92573.1",
    "pot15cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92584.1",
    "pot15cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92585.1",
    "pot15cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92588.1",
    "pot15cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92589.1",
    "pot2.5cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92578.1",
    "pot2.5cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92579.1",
    "pot2.5cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92580.1",
    "pot2.5cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92581.1",
    "pot200cm.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92679.1",
    "pot20cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92592.1",
    "pot20cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92593.1",
    "pot20cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92596.1",
    "pot20cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92597.1",
    "pot30cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92600.1",
    "pot30cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92601.1",
    "pot30cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92602.1",
    "pot30cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92603.1",
    "pot50cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92604.1",
    "pot50cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92605.1",
    "pot50cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92606.1",
    "pot50cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92608.1",
    "pot5cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92509.1",
    "pot5cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92527.1",
    "pot5cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92528.1",
    "pot5cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92529.1",
    "soil0cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92503.1",
    "soil0cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92518.1",
    "soil0cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92516.1",
    "soil0cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92523.1",
    "soil100cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92562.1",
    "soil100cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92564.1",
    "soil100cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92565.1",
    "soil100cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92566.1",
    "soil10cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92538.1",
    "soil10cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92539.1",
    "soil10cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92540.1",
    "soil10cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92541.1",
    "soil2.5cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92530.1",
    "soil2.5cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92531.1",
    "soil2.5cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92532.1",
    "soil2.5cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92533.1",
    "soil200cm.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92568.1",
    "soil20cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92546.1",
    "soil20cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92547.1",
    "soil20cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92548.1",
    "soil20cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92549.1",
    "soil30cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92550.1",
    "soil30cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92551.1",
    "soil30cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92552.1",
    "soil30cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92553.1",
    "soil50cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92554.1",
    "soil50cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92555.1",
    "soil50cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92556.1",
    "soil50cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92557.1",
    "soil5cm_0pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92534.1",
    "soil5cm_50pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92535.1",
    "soil5cm_70pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92536.1",
    "soil5cm_90pctShade.zip" => "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/knb.92537.1",
]

"""
    download_microclim(dir::String; overwrite=false)

Download the microclim-oz dataset to `dir`.

WARNING: This may take many hours, and requires 380 GB of free space when unzipped.

Passing `overwrite=true` will force downloading and unzipping of all files. 
Otherwise only missing files are downloaded and unzipped.
"""
function download_microclim(dir::String; overwrite=false)
    for (filename, url) in microclimoz_files 

        # Download zip file
        filepath = joinpath(dir, filename)
        if !isfile(filepath) || overwrite 
            println("Downloading: ", filepath, "\n    from: ", url)
            download(url, filepath)
        else
            println("Skipping ", filename, ", file exists")
        end

        # Unzip 
        needsunzip = true
        unzipdir = if '_' in filename
            joinpath(dir, match(r"([^_]*).*\.zip", filename).captures[1])
        else
            dir
        end
        out = Pipe()
        zipinfo = run(pipeline(`zipinfo -1 $filepath`; stdout=out), wait=false)
        close(out.in)
        if success(zipinfo)
            zipfiles = map(s -> joinpath(unzipdir, s), split(String(read(out)), "\n"; keepempty=false))
            needsunzip = !all(isfile.(zipfiles))
        else
            error("`zipinfo` for $filepath failed: the file may be corrupted. Delete and run this method again")
        end
        needsunzip && run(`unzip -o $filepath -d $unzipdir`)
    end
end
