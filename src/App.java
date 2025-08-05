import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.Scanner;

public class App {
    public static void main(String[] args) {

        // Obtiene los datos de conexion
        String jdbcURL = "jdbc:mysql://localhost:3306/proyectoBD"; // URL de la base de datos
        String username = "root"; // Usuario de la base de datos
        String password = "hernan1975"; // Contraseña de la base de datos
        
        // intenta establecer la conexión con la base de datos
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Carga el driver de MySQL
            Connection connection = DriverManager.getConnection(jdbcURL, username, password);
            System.out.println("¡Conexion exitosa a MySQL!");

            Scanner scanner = new Scanner(System.in);
            boolean salir = false;
            int opcion = 0;
            do {
                System.out.println("Menu de opciones:");
                System.out.println("1. Insertar Padrino");
                System.out.println("2. Eliminar Donante");
                System.out.println("3. Listar Padrinos y Programas");
                System.out.println("4. Total Aportes Mensuales de un Programa");
                System.out.println("5. Listar Donantes que Aportan a Más de Dos Programas");
                System.out.println("6. Listar Donantes Mensuales y Medios de Pago");
                System.out.println("7. Salir");

                System.out.print("Seleccione una opcion: ");
                opcion = scanner.nextInt();
              

                switch (opcion) {
                    case 1:
                        break;
                    case 2:
                        break;
                    case 3:
                        break;
                    case 4:
                        break;
                    case 5:
                        break;
                    case 6:
                        break;
                    case 7:
                        System.out.println("Saliendo del programa...");
                        salir = true;
                        break;
                    default:
                        System.out.println("Opcion no valida. Por favor, intente de nuevo.");
                        break;

                }

            } while (!salir);

        } catch (SQLException e) {
            System.out.println(
                    "Error al conectar con la base de datos: Recuerde modificar el archivo config.properties con los datos de su base de datos"
                            + e.getMessage());
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("Error inesperado: " + e.getMessage());
            e.printStackTrace();

        }
    }
}
