#import "invoice.typ": render-invoice

#let data = json(sys.inputs.data)

#render-invoice(data)
