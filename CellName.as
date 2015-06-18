package {

	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.filters.GlowFilter;

	public class CellName extends Sprite {
		var format1: TextFormat = new TextFormat();
		private var textField: TextField = new TextField();
		private var _size: Number;
		private var shadow: GlowFilter = new GlowFilter(0, 1.0, 4, 4, 60, 1);

		public function size() {
			return _size;
		}

		public function CellName(_size: Number = 10.0, _text: String = "") {
			super();
			addChild(this.textField);
			this._size = _size;
			this.textField.text = _text;

			this.format1.font = "Verdana";
			this.format1.color = 0xFFFFFF;
			this.format1.underline = false;
			this.textField.selectable = false;

			setSize(_size);

			this.filters = [shadow];

		}

		public function setSize(size: Number): void {
			var nameLength: int = Math.max(Math.floor(1.6 * _size), 20 * this.textField.text.length);
			this.textField.width = nameLength;
			this.format1.size = Math.floor(nameLength / Number(textField.text.length));
			this.textField.setTextFormat(format1);

			textField.x = -textField.textWidth / 2;
			textField.y = -textField.textHeight / 2;
		}
	}
}