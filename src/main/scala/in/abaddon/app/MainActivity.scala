package in.abaddon.app

import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class MainActivity extends AppCompatActivity {
  private lazy val label: TextView = findViewById(R.id.label)

  override protected def onCreate(savedInstanceState: Bundle) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_main)

    label.setText("Meow... Scala World")
  }

}
